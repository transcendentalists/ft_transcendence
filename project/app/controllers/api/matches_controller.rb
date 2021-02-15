class Api::MatchesController < ApplicationController
  def index
    if params[:user_id]
      match_history_list = Match.for_user_index(params[:user_id])
      render :json => {
        matches: match_history_list
      }
    elsif params[:war_id]
      render plain: "This is war " + params[:war_id] + "'s matches"
    else
      render plain: "get /api/matches/index"
    end
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      match = find_or_create_match(user)
      render :json => { match: { id: match.id, match_type: params[:match_type], user: { id: user.id } } }
    elsif params[:war_id]
      render plain: "war creates " + params[:war_id] + "'s matches"
    else
      render plain: "post /api/matches/create"
    end
  end

  def join
    if params[:id]
      render plain: "You just joined " + params[:id] + " match"
    else
      render plain: "The war id is " + params[:war_id] + " and the match is " + params[:match_id]
    end
  end

  def report
    render plain: "You just finished " + params[:id] + " match"
  end

  private
  def find_or_create_match(user)
    if params[:match_type] == "ladder"
      match = find_or_create_ladder_match_for(user)
    elsif params[:match_type] == "dual"
      match = params[:match_id].nil? ? create_dual_match_for(user, params[:rule_id], params[:target_score])
      : join_dual_match_for(user, params[:match_id])
    end
    match
  end

  def find_or_create_ladder_match_for(user)
    match = Match.where(match_type: "Ladder", status: "pending").first_or_create(rule_id: 1)
    side = match.users.count == 0 ? "left" : "right"
    card = Scorecard.create(user_id: user.id, match_id: match.id, side: side)
    user.update_status("playing")
    match
  end

  def create_dual_match_for(user, rule_id, target_score)
    match = Match.create(match_type: "Dual", status: "pending", rule_id: rule_id, target_score: target_score)
    card = Scorecard.create(user_id: user.id, match_id: match.id, side: "left")
    ActionCable.server.broadcast("notification_channel_#{params[:challenger_id].to_s}",
      {type: "dual", status: "approved", match_id: match.id, challenger_id: params[:challenger_id]})
    user.update_status("playing")
    match
  end

  def join_dual_match_for(user, match_id)
    match = Match.find(match_id)
    card = Scorecard.create(user_id: user.id, match_id: match_id, side: "right")
    user.update_status("playing")
    match
  end
end
