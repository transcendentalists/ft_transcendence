class Api::GuildsController < ApplicationController
  def index
    if params[:for] == "guild_index"
      render :json => { guilds: Guild.for_guild_index }
    elsif params[:user_id]
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
    guild = Guild.find_by_id(params[:id])
    if params[:for] == "profile"
      render :json => { guild: guild.profile }
    elsif params[:for] == "guild_detail"
      render :json => { guild_members: Guild.for_guild_detail(params[:id], params[:page]) }
    else
      render plain: "This is " + guild.id.to_s + " 's guilds detail view"
    end
  end

  def update
    render plain: "You just updated " + params[:id] + " guild"
  end

end
