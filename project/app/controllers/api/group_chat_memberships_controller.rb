class Api::GroupChatMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update, :destroy ]

  def update
    params = update_params

    memberships = GroupChatMembership.where(group_chat_room_id: params[:group_chat_room_id])
    return render_error("NOT FOUND", "존재하지 않는 챗룸입니다.", "404") if memberships.nil?
    
    membership = memberships.find_by_id(params[:id])
    # TODO: webadmin check
    # current_user_position = @current_user.web_admin ? "admin" : memberships.find_by_user_id(@current_user.id)
    current_user_position = memberships.find_by_user_id(@current_user.id)&.position
    return render_error("NOT FOUND", "챗룸 멤버 정보를 찾을 수 없습니다.", "404") if membership.nil? || current_user_position.nil?
    
    begin
      if !params[:mute].nil?
        membership.can_be_muted_by?(current_user_position)
        membership.update_mute(params[:mute])
      end

      if !params[:position].nil?
        membership.can_be_position_changed_by?(current_user_position)
        membership.update_position(params[:position])
      end
    rescue
      render_error("BAD REQUEST", "권한이 없거나 형식이 잘못된 요청입니다.", 400)
    end

    render :json => { group_chat_membership: membership }
  end

  def destroy
    memberships = GroupChatMembership.where(group_chat_room_id: params[:group_chat_room_id])
    return render_error("NOT FOUND", "해당하는 챗룸 정보가 없습니다.", "404") if memberships.empty?

    membership = memberships.find_by_id(params[:id])
    return render_error("NOT FOUND", "챗룸에 유저 정보가 없습니다.", "404") if membership.nil?
    return render_error("NOT AUTHORIZED", "권한이 없는 유저입니다.", "403") unless membership.can_be_destroyed_by?(@current_user)

    room = membership.room
    begin
      room.with_lock do
        if room.active_member_count == 1
          room.destroy
        else
          room.make_another_member_owner if membership.position == "owner"
          membership.update_position("ghost")
        end
      end
    rescue
      return render_error("FAILED TO DESTROY", "멤버십 삭제를 실패했습니다.", "500")
    end

    head :no_content, status: 204
  end

  private
  def update_params
    params.permit(:group_chat_room_id, :id, :mute, :position)
  end

end
