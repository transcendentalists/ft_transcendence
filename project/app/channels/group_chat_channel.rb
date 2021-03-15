class GroupChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "group_chat_channel_#{params[:room_id]}"
  end

  def speak(msg)
    begin
      membership = GroupChatMembership.find_by_group_chat_room_id_and_user_id(msg['room_id'], msg['user_id'])
      raise ServiceError.new(:NotFound) if membership.nil?
      return if membership.mute?

      message = ChatMessage.create!(
        user_id: msg['user_id'],
        room_type: 'GroupChatRoom',
        room_id: msg['room_id'],
        message: msg['message']
      )
      msg['created_at'] = message.created_at
      ActionCable.server.broadcast("group_chat_channel_#{msg['room_id']}", msg)
    rescue => e
      put "[ERROR][GroupChatChannel_#{msg['room_id']}][speak] #{e.message}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
