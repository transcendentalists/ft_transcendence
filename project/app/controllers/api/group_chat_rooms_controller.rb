class Api::GroupChatRoomsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index, :show, :update, :destroy]

  def index
    begin
      if params[:for] == "my_group_chat_room_list"
        group_chat_rooms = GroupChatRoom.list_associated_with_user(@current_user)
      elsif params[:channel_code]
        group_chat_rooms = GroupChatRoom.matching_channel_code!(params[:channel_code], @current_user)
      elsif params[:room_type]
        group_chat_rooms = GroupChatRoom.list_filtered_by_type(params[:room_type], @current_user)
      else
        group_chat_rooms = GroupChatRoom.list_all(@current_user)
      end
      render json: { group_chat_rooms: group_chat_rooms }
    rescue => e
      perror e
      render_error :NotFound
    end
  end

  def create
    begin
      room = params[:group_chat_room]
      room[:password] = room[:password].blank? ? nil : BCrypt::Password.create(room[:password])
      room[:channel_code] = GroupChatRoom.generate_channel_code
      raise ServiceError.new(:ServiceUnavailable) if room[:channel_code].nil?
      room = GroupChatRoom.generate!(create_params)
      render :json => { group_chat_room: room }
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message)
    rescue => e
      perror e
      render_error(:Conflict)
    end
  end

  def show
    begin
      group_chat_room = GroupChatRoom.find(params[:id])
      if group_chat_room.locked?
        return render_error(:Unauthorized) unless password_entered?
        return render_error(:Forbidden) unless valid_password?(group_chat_room)
      end
      group_chat_room.enter!(@current_user)
      render json: {
        group_chat_room: group_chat_room.for_chat_room_format,
        owner: group_chat_room.owner.for_chat_room_format,
        current_user: group_chat_room.membership_by_user(@current_user),
        chat_room_members: group_chat_room.members
      }
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message)
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def update
    begin
      room = GroupChatRoom.find(params[:id])
      raise ServiceError.new(:Forbidden) unless room.can_be_update_by?(@current_user)
      room.update_by_params! update_params
      head :no_content, status: 204
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message)
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def destroy
    return render_error(:Forbidden) unless current_user_is_admin_or_owner?
    begin
      room = GroupChatRoom.find(params[:id])
      room.let_all_out_and_destroy!
      head :no_content, status: 204
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  private

  def password_entered?
    !request.headers['Authorization'].nil?
  end

  def valid_password?(group_chat_room)
    group_chat_room.valid_password?(request.headers['Authorization'])
  end

  def create_params
    params.require(:group_chat_room).permit(:owner_id, :room_type, :max_member_count, :title, :password, :channel_code)
  end

  def update_params
    params.require(:group_chat_room).permit(:password)
  end
end
