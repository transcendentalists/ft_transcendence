class Api::GroupChatMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update, :destroy ]

  def update
    begin
      membership = GroupChatMembership.find(params[:id])
      ActiveRecord::Base.transaction do
        membership.update_by_params!({by: @current_user, params: update_params})
      end
      render json: { group_chat_membership: membership }
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
      checkBanTime!
      membership = GroupChatMembership.find(params[:id])
      raise ServiceError.new(:Forbidden) unless membership.can_be_destroyed_by?(@current_user)
      membership.let_out!({ by: @current_user, min: params[:ban_time].to_i })
      head :no_content, status: 204
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message)
    rescue => e
      perror e
      render_error :Conflict
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

  def checkBanTime!
    return if params[:ban_time].nil? || params[:ban_time].blank?
    ban_time = Integer(params[:ban_time])
    if ban_time < 0 || ban_time > 10000
      raise ServiceError.new(:BadRequest, "밴 타임은 0과 1000 사이의 수여야 합니다.")
    end
  end

end
