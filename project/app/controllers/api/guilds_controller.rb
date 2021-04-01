class Api::GuildsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index, :create, :show ]

  def index
    begin
      if params[:for] == "guild_index"
        render json: { guilds: Guild.for_guild_index(params[:page].to_i) }
      else
        raise ServiceError.new :BadRequest
      end
    rescue ServiceError => e
      perror e
      render_error e.type
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def create
    begin
      raise ServiceError.new :BadRequest if @current_user.in_guild
      ActiveRecord::Base.transaction do
        guild = Guild.create!(create_params)
        guild_membership = guild.memberships.create!({ user_id: @current_user.id, guild_id: guild.id, position: "master" })
        @current_user.guild_invitations.destroy_all
        image_attach!(guild)
        render json: { guild_membership: guild_membership.profile }
      end
    rescue ServiceError => e
      perror e
      render_error e.type
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def show
    begin
      guild = Guild.find(params[:id])
      if params[:for] == "profile"
        guild_data = guild.profile
      else
        raise ServiceError.new :BadRequest
      end
      render json: { guild: guild_data }
    rescue ServiceError => e
      perror e
      render_error e.type
    rescue => e
      perror e
      render_error :NotFound
    end
  end

  private

  def create_params
    {
      name: params[:name],
      anagram: '@' + params[:anagram],
      owner_id: @current_user.id,
    }
  end

  def image_attach!(guild)
    if params.has_key?(:file)
      guild.image.purge if guild.image.attached?
      guild.image.attach(params[:file])
      guild.image_url = url_for(guild.image)
      guild.save!
    end
  end
end
