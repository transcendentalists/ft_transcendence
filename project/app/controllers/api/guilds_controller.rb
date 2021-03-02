class Api::GuildsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create ]

  def index
    if params[:for] == "guild_index"
      render json: { guilds: Guild.for_guild_index(params[:page].to_i) }
    end
  end

  def create
    ActiveRecord::Base.transaction do
      return render_error("길드 생성 실패", "이미 소속된 길드가 있습니다.", 400) if @current_user.in_guild
      begin
        guild = Guild.new(
          name: params[:name],
          anagram: '@' + params[:anagram],
          owner_id: @current_user.id,
        )
        unless guild.valid?
          error_attribute_name = guild.errors.attribute_names.first
          raise ArgumentError.new guild.errors[error_attribute_name].first
        end
        guild.save!
        guild_membership = guild.create_membership(@current_user.id, "master")
        image_attach(guild)
        render json: { guild: guild_membership.profile }
      rescue => e
        if e.class == ArgumentError
          render_error("길드 생성 실패", e.message, 400)
        else
          render_error("길드 생성 실패", "잘못된 요청입니다.", 400)
        end
        raise ActiveRecord::Rollback
      end
    end
  end

  def show
    guild = Guild.find_by_id(params[:id])
    return render_error("길드 검색 에러", "요청하신 길드의 정보가 없습니다.", 404) if guild.nil?
    if params[:for] == "profile"
      guild_data = guild.profile
    else
      return render_error("올바르지 않은 요청", "요청하신 정보가 없습니다.", 400)
    end
    render json: { guild: guild_data }
  end

  def update
    render plain: "You just updated " + params[:id] + " guild"
  end

  private
  def image_attach(guild)
    if params.has_key?(:file)
      guild.image.purge if guild.image.attached?
      guild.image.attach(params[:file])
      guild.image_url = url_for(guild.image)
      guild.save!
    end
  end

end
