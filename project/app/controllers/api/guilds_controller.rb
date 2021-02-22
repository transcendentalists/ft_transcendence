class Api::GuildsController < ApplicationController
  def index
    if params[:for] == "guild_index"
      render :json => { guilds: Guild.for_guild_index }
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
