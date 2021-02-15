class Api::GroupChatRoomsController < ApplicationController
  
  # list_all scope 미구현 상태(admin 개발시 구현)
  def index
    if params[:for] == 'my_group_chat_room_list'
      group_chat_rooms = GroupChatRoom.list_associated_with_current_user(params[:current_user_id])
    elsif params[:channel_code]
      group_chat_rooms = GroupChatRoom.find_by_channel_code(params[:channel_code])
      return render_error("NOT FOUND", "채널을 찾을 수 없습니다.", 404) if group_chat_rooms.nil?
    elsif params[:room_type]
      group_chat_rooms = GroupChatRoom.list_filtered_by_type(params[:room_type], params[:current_user_id])
    else
      group_chat_rooms = GroupChatRoom.list_all(params[:current_user_id])
    end
    render :json => { group_chat_rooms: group_chat_rooms }
  end

  def create
    render plain: "group chat room create"
  end

  def join
    render plain: "group chat room join"
  end

  def show
    render plain: params[:id] + " group chat room show"
  end

  def update
    render plain: params[:id] + " group chat room update"
  end

  def destroy
    render plain: params[:id] + " group chat room destroy"
  end

end
