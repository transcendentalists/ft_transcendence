class Api::GroupChatMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update, :destroy ]

  def update
    begin
      membership = GroupChatMembership.find(params[:id])
      membership.update_by_params!({by: @current_user, params: update_params})
      render json: { group_chat_membership: membership }
    rescue ServiceError => e
      render_error(e.type, e.message)
    rescue
      render_error :InternalServerError
    end
  end

  def destroy
    begin
      membership = GroupChatMembership.find(params[:id])
      raise ServiceError.new(:Forbidden) unless membership.can_be_destroyed_by?(@current_user)
      membership.let_out!({by: @current_user})
      head :no_content, status: 204
    rescue ServiceError => e
      render_error(e.type, e.message)
    rescue
      render_error :InternalServerError
    end
  end

  private

  def update_params
    params.require(:group_chat_membership) unless current_user_is_admin_or_owner?
    {
      id: params[:id],
      mute: params[:mute],
      position: params[:position]
    }
  end

end
