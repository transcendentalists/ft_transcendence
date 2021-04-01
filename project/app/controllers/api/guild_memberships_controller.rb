class Api::GuildMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create, :update, :destroy ]

  def index
    begin
      guild = Guild.find(params[:guild_id])
      if params[:for] == "member_list"
        guild_memberships = GuildMembership.for_members_ranking(params[:guild_id], params[:page])
      else
        raise ServiceError.new :BadRequest
      end
      render json: { guild_memberships: guild_memberships }
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
      ServiceError.new(:Forbidden) if @current_user.id != params[:user][:id] || @current_user.in_guild?
      ServiceError.new(:NotFound) unless Guild.exists?(params[:guild_id])
      guild_membership = GuildMembership.create!(create_params)
      @current_user.guild_invitations.destroy_all
      render json: { guild_membership: guild_membership.profile }
    rescue ServiceError => e
      render_error e.type
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def update
    begin
      guild_membership = GuildMembership.find(params[:id])
      guild_membership.update_position!(params[:position], {by: @current_user})
      render json: { guild_membership: guild_membership.profile }
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message)
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def destroy
    begin
      membership = GuildMembership.find(params[:id])
      raise ServiceError.new :Forbidden unless membership.can_be_destroyed_by?(@current_user)
      ActiveRecord::Base.transaction do
        membership.unregister!
      end
      head :no_content, status: 204
    rescue ServiceError => e
      render_error e.type
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  private

  def create_params
  {
    user_id: params[:user][:id],
    guild_id: params[:guild_id],
    position: params[:position],
  }
  end

end
