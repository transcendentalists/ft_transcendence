class Api::GroupChatMembershipsController < ApplicationController
  def index
    render plain: params[:group_chat_room_id] + " memberships index"
  end

  def create
    render plain: params[:group_chat_room_id] + " creates group chat membership"
  end

  def update
    render plain: params[:group_chat_room_id] + " group chat room updates " + params[:id] + " membership"
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

  def destroy_params
    params.require(:group_chat_room_id)
    params.require(:id)
    params.permit(:group_chat_room_id, :id)
  end
end
