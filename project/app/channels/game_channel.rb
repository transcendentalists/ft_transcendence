class GameChannel < ApplicationCable::Channel

  # match_id를 기준으로 채널 생성
  # 종료/취소된 매치, 경기 인원이 편성되지 않은 매치 접근에 대한 예외처리 진행
  def subscribed
    current_user.reload
    reject if current_user.status == "offline"
    stream_from "game_channel_#{params[:match_id].to_s}"

    @match = Match.find_by_id(params[:match_id])
    return stop(params[:match_id]) if @match.nil? || @match.completed_or_canceled?
    
    current_user.ready_match(@match) if @match.player?(current_user)
    return unless @match.ready?
    return if @match.users.count < 2 || !@match.scorecards.reload.find_by_result("wait").nil?
    not_started = @match.status == "pending"
    @match.start if not_started
    enter(not_started)
  end

  # 유효하지 않은 매치 접근시 예외처리
  def stop(match_id)
    speak({match_id: match_id, type: "STOP", message: "INVALID MATCH", send_id: current_user.id })
  end

  # 토너먼트의 경우 바로 게임을 시작할 수 없으므로 일찍 들어온 경우 대기 메시지 전송
  # 이후 처리는 토너먼트 구현시 상세 설계 필요
  def wait_start
    speak({match_id: @match.id, type: "WAIT", message: "NOT YET STARTED", start_time: @match.start_time, send_id: current_user.id })
  end

  # 경기 정보(spec) 발송
  # 게임 시작(START)이냐 게스트 중간 입장(ENTER)이냐에 따라 메시지 타입 구분ㄴ
  def enter(not_started)
    left = @match.scorecards.find_by_side('left').user
    right = @match.scorecards.find_by_side('right').user
    speak({match_id: @match.id, type: not_started ? "START" : "ENTER",
            left: left.profile, right: right.profile,
            target_score: @match.target_score, rule: @match.rule,
            send_id: current_user.id })
  end

  def speak(msg)
    id = msg[:match_id] || msg['match_id']
    ActionCable.server.broadcast("game_channel_#{id.to_s}", msg)
  end

  # 게임에서 실점했을 때 스코어카드를 업데이트하며
  # 정해진 점수가 되었을 때 게임을 종료시킴
  def losePoint(msg)
    @match = Match.find(msg['match_id'])
    card = @match.scorecards.where.not(side: msg['side']).first
    card.score += 1
    card.save
    complete_by_match_end(card.user.id) if (@match.target_score == card.score)
  end

  # 게임의 승패에 따라 유저의 포인트를 업데이트
  def update_game_status
    @match.users.each do |user|
      if user == @match.winner
        user.update(point: user.point + 20)
      else
        user.update(point: user.point + 5)
      end
    end
    @match.update(status: "completed")
  end

  # 1) 게임이 정상적으로 종료된 경우에 스코어카드를 기준으로 승/패를 업데이트
  # 2) 유저의 상태를 "progress" -> "online"으로 변경
  # -> TODO: user.rb 퍼블릭 메서드 구현시 변경
  # 3) 승/패에 따라 유저의 포인트를 업데이트
  def complete_by_match_end(winner_id)
    @match.scorecards.each do |card|
      card.update(result: card.score == @match.target_score ? "win" : "lose")
    end
    update_game_status
    send_complete_message("END", winner_id)
  end

  # 정상적이지 않은 경로로 게임이 종료되었을 때를 감지하여
  # 게임을 '종료' 상태로 바꾸고 유저의 승패를 업데이트
  def complete_by_giveup
    @match = current_user.playing_match
    return if @match.nil? or @match.status == "completed"

    @match.scorecards.each do |card|
      card.update(result: card.user.id == current_user.id ? "lose" : "win")
    end
    winner_id = current_user.enemy
    @match.update(status: "completed")

    send_complete_message("ENEMY_GIVEUP", winner_id)
  end

  # 게임의 승패와 종료여부를 채널에 알리고
  # 해당 채널의 모든 스트림을 종료
  def send_complete_message(type, winner_id)
    msg = {
      send_id: 0,
      match_id: @match.id, type: type,
      winner_id: winner_id,
      left: @match.scorecards.find_by_side('left'),
      right: @match.scorecards.find_by_side('right'),
    };
    speak msg
    stop_all_streams
  end

  def unsubscribed
    if current_user.waiting_match?
      current_user.waiting_match.cancel
    elsif current_user.playing?
      complete_by_giveup
    end
    current_user.update_status("online")
    # Any cleanup needed when channel is unsubscribed
  end
end
