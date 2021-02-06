class GameChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "DEBUG:: subscribed"
    @match = Match.find(params[:match_id])
    reject if current_user.status == "offline"
    stream_from "game_channel_#{params[:match_id].to_s}"

    return stop(params[:match_id]) if (@match.nil? or ["completed", "canceled"].include?(@match.status))
    return wait_start if @match.match_type == "tournament" && Time.now < @match.start_time
    return if @match.users.count < 2
    not_started = @match.status == "pending"
    @match.start if not_started
    enter(not_started)
  end
  
  def stop(match_id)
    speak({match_id: match_id, type: "STOP", message: "INVALID MATCH", send_id: current_user.id })
  end

  def wait_start
    speak({match_id: @match.id, type: "WAIT", message: "NOT YET STARTED", start_time: @match.start_time, send_id: current_user.id })
  end

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

  def losePoint(msg)
    @match = Match.find(msg['match_id'])
    card = @match.scorecards.where.not(side: msg['side']).first
    card.score += 1
    card.save
    complete_by_match_end(card.user.id) if (@match.target_score == card.score)
  end

  def complete_by_match_end(winner_id)
    @match.scorecards.each do |card|
      card.update(result: card.score == @match.target_score ? "win" : "lose")
      card.user.update(status: "online")
    end
    @match.update(status: "completed")
    
    send_complete_message("END", winner_id)
  end

  def complete_by_giveup
    @match = current_user.playing_game
    return if @match.nil? or @match.status == "completed"
    
    @match.scorecards.each do |card|
      card.update(result: card.user.id == current_user.id ? "lose" : "win")
    end
    @match.update(status: "completed")

    send_complete_message("ENEMY_GIVEUP", current_user.id)
  end

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
    complete_by_giveup if current_user.playing?
    # Any cleanup needed when channel is unsubscribed
  end
end
