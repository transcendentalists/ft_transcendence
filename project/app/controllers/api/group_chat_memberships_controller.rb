class Api::GroupChatMembershipsController < ApplicationController
  def index
    render plain: params[:group_chat_room_id] + " memberships index"
  end

  def create
    render plain: params[:group_chat_room_id] + " creates group chat membership"
  end

  def update
    params = update_params
    render_error("BAD REQUEST", "권한이 없거나 형식이 잘못된 요청입니다.", 400) if params.nil?
    
    membership = params[:member_membership]
    membership = membership.update_mute(params) unless params[:mute].nil?
    membership = membership&.update_position(params) unless params[:position].nil?

    if membership
      render :json => { group_chat_membership: membership }
    else
      render_error("BAD REQUEST", "권한이 없거나 형식이 잘못된 요청입니다.", 400)
    end
  end

  def destroy
    # TODO: 
    # 1. 구독하고 있던 채널 끊기
    # 2. 나간 멤버가 오너라면 다른 멤버를 오너로 만들 것
    if GroupChatMembership.deleteChatRoomMembershipOfuser(destroy_params)
      render plain: "success to " + params[:group_chat_room_id] + 
                    " group chat room destroy " + params[:id] + " membership"
    else
      render_error("NOT FOUND", "해당하는 챗룸/유저 정보가 없습니다.", "404")
    end
  end

  private

  def update_params
    admin_membership = GroupChatMembership.find_by_user_id_and_group_chat_room_id(params[:admin_id], params[:group_chat_room_id])
    member_membership = GroupChatMembership.find_by_user_id_and_group_chat_room_id(params[:member_id], params[:group_chat_room_id])
    return nil if admin_membership.nil? || member_membership.nil?
    return nil if params[:mute].nil? && params[:position].nil?
    { admin_membership: admin_membership, member_membership: member_membership, mute: params[:mute], position: params[:position]}
  end

  def destroy_params
    params.require(:group_chat_room_id)
    params.require(:id)
    params.permit(:group_chat_room_id, :id)
  end
  
end
