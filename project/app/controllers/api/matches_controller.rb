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
      render plain: "user creates " + params[:user_id] + "'s matches"
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
end
