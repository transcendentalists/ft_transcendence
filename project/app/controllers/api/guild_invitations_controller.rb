class Api::GuildInvitationsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create, :destroy ]

  def index
    begin
      guild_invitations = GuildInvitation.for_user_index(params[:user_id])
      render json: { guild_invitations: guild_invitations }      
    rescue
      render_error :Conflict
    end
  end

  def create
    begin
      raise ServiceError.new if @current_user.id != params[:user_id].to_i
      guild_invitation = GuildInvitation.create!(create_params)
      render json: { guild_invitation: guild_invitation.id }
    rescue ActiveRecord::RecordInvalid => e
      key =  e.record.errors.attribute_names.first
      error_message = e.record.errors.messages[key].first
      render_error(:BadRequest, error_message)
    rescue
      render_error :BadRequest
    end
  end

  def destroy
    begin
      guild_invitation = GuildInvitation.find(params[:id])
      raise ServiceError.new(:Forbidden) if @current_user.id != guild_invitation.invited_user_id
      guild_invitation.destroy!
      head :no_content, status: 204
    rescue ServiceError => e
      render_error e.type
    rescue
      render_error :Conflict
    end
  end

  private

  def create_params
    params.permit(:user_id, :invited_user_id, :guild_id)
  end
end
