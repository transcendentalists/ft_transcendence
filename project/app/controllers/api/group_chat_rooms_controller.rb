class Api::GroupChatRoomsController < ApplicationController
  def index
    if params[:for] == 'my_group_chat_room_list'
      group_chatrooms = GroupChatRoom.list_associated_with_current_user(params[:current_user_id])
    else
      if params[:room_type]
        group_chatrooms = GroupChatRoom.list_filtered_by_type(params[:room_type], params[:current_user_id])
      else
        group_chatrooms = GroupChatRoom.list_all(params[:current_user_id])
      end
    end
    render :json => { group_chat_rooms: group_chatrooms }
  end

  def create
    room = params[:group_chat_room]
    return render_error("not found", "group_chat_room key가 없습니다.", 404) if room.nil?
    room[:password] = BCrypt::Password.create(room[:password]) if room.has_key?(:password)
    room[:channel_code] = generate_chat_room_code
    return render_error("create failed", "이미 개설된 룸이 너무 많습니다. 관리자에게 문의하세요.", 503) if room[:channel_code].nil?
    room = GroupChatRoom.create(create_params)
    return render_error("create failed", "parameter가 유효하지 않습니다.", 403) if not room.persisted?
    render :json => { group_chat_room: room }
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

  private
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
