class DirectChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "direct_chat_channel_#{params[:room_id]}"
  end

  def speak(msg)
    ChatMessage.create(
      user_id: msg['user_id'],
      room_type: 'DirectChatRoom',
      room_id: DirectChatRoom.find_by_symbol(msg['room_id']).id,
      message: msg['message']
    )

    ActionCable.server.broadcast("direct_chat_channel_#{msg['room_id']}", msg)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
