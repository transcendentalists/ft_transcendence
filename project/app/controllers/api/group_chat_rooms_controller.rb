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
    room = params[:group_chat_room]
    return render_error("not found", "group_chat_room key가 없습니다.", 404) if room.nil?
    if room.has_key?(:password) && room[:password] != ""
      room[:password] = BCrypt::Password.create(room[:password]) 
    else
      room[:password] = nil
    end
    room[:channel_code] = generate_chat_room_code
    return render_error("create failed", "이미 개설된 룸이 너무 많습니다. 관리자에게 문의하세요.", 503) if room[:channel_code].nil?
    room = GroupChatRoom.generate(create_params)
    return render_error("create failed", "parameter가 유효하지 않습니다.", 403) if room.nil?
    render :json => { group_chat_room: room }
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
    group_chat_room = GroupChatRoom.find_by_id(params[:id])
    return render_error("NOT FOUND", "ChatRoom을 찾을 수 없습니다.", "404") if group_chat_room.nil? 
    group_chat_room.update_by_params update_chat_room_params
    head :no_content, status: 204
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

  def update_chat_room_params
    params.require(:group_chat_room).permit(:title, :password, :room_type)
  end

  def create_params
    params.require(:group_chat_room).permit(:owner_id, :room_type, :max_member_count, :title, :password, :channel_code)
  end

  def generate_chat_room_code
    10.times do
      code = ""
      9.times { code << (65 + rand(25)).chr }
      code.insert(3, '-')
      code.insert(7, '-')
      return code if GroupChatRoom.find_by_channel_code(code).nil?
    end
    nil
  end

end
