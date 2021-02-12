class DirectChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "diret_chat_channel_#{params[:room_id]}"
  end

  def send(msg)
    ActionCable.server.broadcast("direct_chat_channel_#{msg[:room_id]}", msg)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
