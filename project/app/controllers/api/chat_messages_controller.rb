class Api::ChatMessagesController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index, :create ]

  def index
    begin
      if current_user_is_admin_or_owner?
        chat_messages = GroupChatRoom.find(params[:group_chat_room_id]).for_admin_format
      else
        chat_messages = GroupChatRoom.find(params[:group_chat_room_id])&.messages&.last(20)
      end
      render json: { chat_messages: chat_messages }
    rescue => e
      perror e
      render_error :NotFound
    end
  end

end
