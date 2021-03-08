class Api::ChatMessagesController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index ]

  def index
    if current_user_is_admin_or_owner?
      chat_messages = GroupChatRoom.find_by_id(params[:group_chat_room_id]).for_admin_format
    else
      chat_messages = GroupChatRoom.find_by_id(params[:group_chat_room_id])&.messages&.last(20)
      return render_error("NOT FOUND", "ChatMessage들을 찾을 수 없습니다.", "404") if chat_messages.nil?
    end
    
    render json: { chat_messages: chat_messages }
  end

  def create
    if params[:group_chat_room_id]
      render plain: params[:group_chat_room_id] + " group chat message created"
    else
      render plain: params[:direct_chat_room_id] + " direct chat message created"
    end
  end

end
