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
    user_id = params[:id]
    guild_id = User.includes(:in_guild).find(user_id).profile[:guild]['id']
    guild = Guild.find(guild_id)
    if params[:for] == "profile"
      render :json => { guild: guild.profile(user_id) }
    else
      render plain: "This is " + guild_id + " 's guilds detail view"
    end
  end

  def update
    render plain: "You just updated " + params[:id] + " guild"
  end

end
