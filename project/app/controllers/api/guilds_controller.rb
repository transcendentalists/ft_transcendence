class Api::GuildsController < ApplicationController
  def index
    if params[:for] == "guild_index"
      render :json => { guilds: Guild.for_guild_index(params[:page].to_i) }
    end
  end

  def create
    render plain: "post /api/guilds#create"
  end

  def show
    guild = Guild.find_by_id(params[:id])
    return render_error("길드 검색 에러", "요청하신 길드의 정보가 없습니다.", 404) if guild.nil?
    if params[:for] == "profile"
      render :json => { guild: guild.profile }
    end
  end

  def update
    render plain: "You just updated " + params[:id] + " guild"
  end

end
