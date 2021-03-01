class Api::GuildsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create ]

  def index
    if params[:for] == "guild_index"
      render json: { guilds: Guild.for_guild_index(params[:page].to_i) }
    end
  end

  def create
    return render_error("길드 생성 실패", "이미 소속된 길드가 있습니다.", 400) if @current_user.in_guild
    guild = Guild.new(
      name: params[:name],
      anagram: '@' + params[:anagram],
      owner_id: @current_user.id,
    )
    return render_error("길드 생성 실패", "길드 생성에 실패하였습니다.", 400) if guild.nil?
    unless guild.valid?
      error_attribute_name = guild.errors.attribute_names[0]
      return render_error("길드 생성 실패", guild.errors[error_attribute_name], 400) 
    end
    guild.save
    if params.has_key?(:file)
      guild.image.purge if guild.image.attached?
      guild.image.attach(params[:file])
      guild.image_url = url_for(guild.image)
      guild.save
    else
      return render_error("올바르지 않은 요청", "이미지를 찾을 수 없습니다.", 404)
    end
    guild_membership = guild.create_membership(@current_user.id, "master")
    return render_error("길드 멤버십 생성 실패", "길드가 없거나 잘못된 요청입니다.", 400) if guild_membership.nil?
    render json: { guild: guild_membership.profile }
  end

  def show
    guild = Guild.find_by_id(params[:id])
    return render_error("길드 검색 에러", "요청하신 길드의 정보가 없습니다.", 404) if guild.nil?
    if params[:for] == "profile"
      guild_data = guild.profile
    elsif params[:for] == "member_ranking"
      guild_data = guild.for_member_ranking(params[:page])
    else
      return render_error("올바르지 않은 요청", "요청하신 정보가 없습니다.", 400)
    end
    render json: { guild: guild_data }
  end

  def update
    render plain: "You just updated " + params[:id] + " guild"
  end

end
