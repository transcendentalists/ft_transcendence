class GameChannel < ApplicationCable::Channel

  # match_id를 기준으로 채널 생성
  # 종료/취소된 매치, 경기 인원이 편성되지 않은 매치 접근에 대한 예외처리 진행
  def subscribed
    current_user.reload
    reject if current_user.status == "offline"
    stream_from "game_channel_#{params[:match_id].to_s}"

    @match = Match.find_by_id(params[:match_id])
    return stop(params[:match_id]) if @match.nil? || @match.completed_or_canceled?
    return loading(params[:match_id]) if !@match.reload.loading_end? && !@match.player?(current_user)
    current_user.ready_for_match(@match) if @match.player?(current_user)
    return if @match.pending? && !@match.ready_to_start?

    # 이미 시작한 상황이므로, 게임이 시작한 후에 들어오는 모든 user는 관전.
    @match.ready_to_start? ? @match.start : @match.broadcast({type: "WATCH", send_id: current_user.id})
  end

  # 유효하지 않은 매치 접근시 예외처리
  def stop(match_id)
    speak({match_id: match_id, type: "STOP", message: "INVALID MATCH", send_id: current_user.id })
  end

  # 유효하지 않은 매치 접근시 예외처리
  def loading(match_id)
    speak({match_id: match_id, type: "LOADING", message: "아직 경기가 시작되지 않았습니다.", send_id: current_user.id })
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

  # 1) 게임이 정상적으로 종료된 경우에 스코어카드를 기준으로 승/패를 업데이트
  # 2) 유저의 상태를 "progress" -> "online"으로 변경
  # -> TODO: user.rb 퍼블릭 메서드 구현시 변경
  # 3) 승/패에 따라 유저의 포인트를 업데이트
  def complete_by_match_end(winner_id)
    @match.scorecards.each do |card|
      card.update(result: card.score == @match.target_score ? "win" : "lose")
    end
    @match.update_game_status
    @match.complete({type: "END"})
    stop_all_streams
  end

  # 정상적이지 않은 경로로 게임이 종료되었을 때를 감지하여
  # 게임을 '종료' 상태로 바꾸고 유저의 승패를 업데이트
  def complete_by_giveup
    @match = current_user.playing_match
    return if @match.nil? || @match.status == "completed"

    @match.scorecards.each do |card|
      card.update(result: card.user.id == current_user.id ? "lose" : "win")
    end
    winner_id = current_user.enemy
    @match.complete({type: "ENEMY_GIVEUP"})

    stop_all_streams
  end

  def unsubscribed
    if current_user.waiting_match?
      current_user.waiting_match.cancel
    elsif current_user.playing?
      complete_by_giveup
    end
    current_user.update_status("online")
  end
end
