class Api::ChatMessagesController < ApplicationController
  def index
    if params[:group_chat_room_id]
      render plain: params[:group_chat_room_id] + " group chat message index"
    else
      render plain: params[:direct_chat_room_id] + " direct chat message index"
    end
  end

  def create
    if params[:group_chat_room_id]
      render plain: params[:group_chat_room_id] + " group chat message created"
    else
      render plain: params[:direct_chat_room_id] + " direct chat message created"
    end
  end
end
