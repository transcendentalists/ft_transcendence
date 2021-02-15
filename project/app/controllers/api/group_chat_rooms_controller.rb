class Api::GroupChatRoomsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [:show ]
  
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

  def show
    group_chat_room = GroupChatRoom.find_by_id(params[:id])
    if group_chat_room.nil?
      return render_error("NOT FOUND", "ChatRoom을 찾을 수 없습니다.", "404")
    end

    # if group_chat_room.locked?
    #   input_password = request.headers['authorization']
    #   if input_password.nil?
    #     return render_error("EMPTY PASSWORD", "Password가 입력되지 않았습니다.", "401")
    #   end
    #   if group_chat_room.is_valid_password(input_password)
    #     return render_error("INVALID PASSWORD", "Password가 일치하지 않습니다.", "403")
    #   end
    # end

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
    render plain: params[:id] + " group chat room destroy"
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
end
