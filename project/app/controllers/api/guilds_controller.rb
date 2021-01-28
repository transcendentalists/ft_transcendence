class Api::GuildsController < ApplicationController
  def index
    if params[:user_id]
      render plain: "This is user " + params[:user_id] + "'s matches"
    elsif params[:war_id]
      render plain: "This is war " + params[:war_id] + "'s matches"
    else
      render plain: "get /api/guilds#index"
    end
  end

  def create
    render plain: "post /api/guilds#create"
  end

  def show
    render plain: "This is " + params[:id] + " 's guilds detail view"
  end

  def update
    render plain: "You just updated " + params[:id] + " guild"
  end

  def test

  end
end
