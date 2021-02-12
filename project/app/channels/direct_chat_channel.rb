class DirectChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "direct_chat_channel_#{params[:room_id]}"
  end

  def speak(msg)
    ActionCable.server.broadcast("direct_chat_channel_#{msg[:room_id]}", msg)
  end

  def unsubscribed
    p 'debug: direct_chat_channel_unsubscribe'
    # Any cleanup needed when channel is unsubscribed
  end
end
