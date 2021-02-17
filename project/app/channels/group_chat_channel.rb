class GroupChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "group_chat_channel_#{params[:room_id]}"
  end

  def speak(msg)
    membership = GroupChatMembership.find_by_user_id(msg['user_id'])
    return if membership.nil? || membership.mute

    ChatMessage.create(
      user_id: msg['user_id'],
      room_type: 'GroupChatRoom',
      room_id: msg['room_id'],
      message: msg['message']
    )

    ActionCable.server.broadcast("group_chat_channel_#{msg['room_id']}", msg)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
