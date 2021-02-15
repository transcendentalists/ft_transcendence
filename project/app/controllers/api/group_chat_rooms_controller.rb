class Api::GroupChatRoomsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [:show, :index, :destroy]
  
  # list_all scope 미구현 상태(admin 개발시 구현)
  def index
    if params[:for] == 'my_group_chat_room_list'
      group_chat_rooms = GroupChatRoom.list_associated_with_current_user(@current_user)
    elsif params[:channel_code]
      group_chat_rooms = GroupChatRoom.matching_channel_code(params[:channel_code], @current_user)
      return render_error("NOT FOUND", "채널을 찾을 수 없습니다.", 404) if group_chat_rooms.nil?
    elsif params[:room_type]
      group_chat_rooms = GroupChatRoom.list_filtered_by_type(params[:room_type], @current_user)
    else
      group_chat_rooms = GroupChatRoom.list_all(@current_user)
    end
    render :json => { group_chat_rooms: group_chat_rooms }
  end

  def create
    render plain: "group chat room create"
  end

  def show
    group_chat_room = GroupChatRoom.find_by_id(params[:id])
    return render_error("NOT FOUND", "ChatRoom을 찾을 수 없습니다.", "404") if group_chat_room.nil?

    if group_chat_room.is_locked?
      return render_error("EMPTY PASSWORD", "Password가 입력되지 않았습니다.", "401") unless is_password_entered?
      return render_error("INVALID PASSWORD", "Password가 일치하지 않습니다.", "403") unless is_valid_password?(group_chat_room)
    end

    render json: { 
      group_chat_room: group_chat_room.for_chat_room_format,
      owner: group_chat_room.owner.for_chat_room_format,
      current_user: group_chat_room.current_user_info(@current_user),
      chat_room_members: group_chat_room.members
    }
  end

  def update
    render plain: params[:id] + " group chat room update"
  end

  def destroy
    # group_chat_room = GroupChatRooms.find_by_id(params[:id])
    # if group_chat_room.is_user_authorized_to_destroy(@current_user)
    #   group_chat_room.destroy
    # else
    #   return render_error("UNAUTHORIZED", "삭제 권한이 없습니다.", "403")
    # end
    render plain: "group chat room destroy"
  end

  private
  
  def check_headers_and_find_current_user
    if !request.headers['HTTP_CURRENT_USER']
      return render_error("NOT VALID HEADERS", "요청 Header가 유효하지 않습니다.", "400")
    end
    @current_user = User.find_by_id(request.headers['HTTP_CURRENT_USER'])
    if @current_user.nil?
      return render_error("NOT VALID HEADERS", "요청 Header가 유효하지 않습니다.", "400")
    end
  end

  def is_password_entered?
    !request.headers['authorization'].nil?
  end

  def is_valid_password?(group_chat_room)
    group_chat_room.is_valid_password?(request.headers['Authorization'])
  end
end
