class Api::MatchesController < ApplicationController
  def index
    if params[:user_id]
      render plain: "This is user " + params[:user_id] + "'s matches"
    elsif params[:war_id]
      render plain: "This is war " + params[:war_id] + "'s matches"
    else
      render plain: "get /api/matches/index"
    end
  end

  def create
    if params[:user_id]
      return if not is_current_user(params[:user_id])
      user = User.find(params[:user_id])
      match = find_or_create_ladder_match_for user
      render :json => { match: { id: match.id, match_type: 'ladder', user: { id: user.id } } }
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
  def find_or_create_ladder_match_for(user)
    match = Match.where(match_type: "ladder", status: "pending").first_or_create(rule_id: 5)
    side = match.users.count == 0 ? "left" : "right"
    card = Scorecard.create(user_id: user.id, match_id: match.id, side: side)
    user.update(status: "playing")
    match
  end
end
