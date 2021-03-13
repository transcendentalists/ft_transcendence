class GameChannel < ApplicationCable::Channel

  # match_id를 기준으로 채널 생성
  # 종료/취소된 매치, 경기 인원이 편성되지 않은 매치 접근에 대한 예외처리 진행
  def subscribed
    current_user.reload
    reject if current_user.status == "offline"
    stream_from "game_channel_#{params[:match_id].to_s}"

    begin
      @match = Match.find_by_id(params[:match_id])
      raise GameError.new(:STOP) if @match.nil? || @match.completed_or_canceled?
      raise GameError.new(:LOADING) if !@match.reload.loading_end? && !@match.player?(current_user)
    
      current_user.ready_for_match(@match) if @match.player?(current_user)
      return if @match.pending? && !@match.ready_to_start?

      if @match.ready_to_start? 
        @match.start!
      else
        @match.broadcast({type: "WATCH", send_id: current_user.id})
      end
    rescue GameError => e
      broadcast e.type
      put "[ERROR][GameChannel_#{params[:match_id]}][subscribed] #{e.message}"
    rescue
      broadcast :STOP
      put "[ERROR][GameChannel_#{params[:match_id]}][subscribed] #{e.message}"
    end
  end

  def speak(msg)
    ActionCable.server.broadcast("game_channel_#{@match.id.to_s}", msg)
  end

  # 게임에서 실점했을 때 스코어카드를 업데이트하며
  # 정해진 점수가 되었을 때 게임을 종료시킴
  def losePoint(msg)
    begin
      @match.reload
      card = @match.scorecards.where.not(side: msg['side']).first
      card.increment!(:score, 1)
      complete_by_match_end(card.user.id) if (@match.target_score == card.score)      
    rescue => e
      @match.cancel
      broadcast :CONFLICT
      put "[ERROR][GameChannel][losePoint] #{e.message}"
    end
  end

  def complete_by_match_end(winner_id)
    begin
      ActiveRecord::Base.transaction do
        @match.scorecards.each do |card|
          card.update!(result: card.score == @match.target_score ? "win" : "lose")
        end
        @match.complete({type: "END"})
      end
    rescue
      broadcast :CONFLICT
    end
    stop_all_streams
  end

  # 정상적이지 않은 경로로 게임이 종료되었을 때를 감지하여
  # 게임을 '종료' 상태로 바꾸고 유저의 승패를 업데이트
  def complete_by_giveup
    @match.reload
    raise GameError.new(:STOP) if @match.status == "completed"
    ActiveRecord::Base.transaction do
      @match.scorecards.each do |card|
        card.update!(result: card.user.id == current_user.id ? "lose" : "win")
      end
      winner_id = current_user.enemy
      @match.complete({type: "ENEMY_GIVEUP"})    
    end
    stop_all_streams
  end

  def broadcast(type = :STOP)
    speak({match_id: @match.id, type: type.to_s, send_id: current_user.id })
  end

  def unsubscribed
    begin
      if current_user.waiting_match?
        current_user.waiting_match.cancel
      elsif current_user.playing?
        complete_by_giveup
      end
      current_user.update_status("online")
    rescue
      broadcast :STOP
    end
  end
end
