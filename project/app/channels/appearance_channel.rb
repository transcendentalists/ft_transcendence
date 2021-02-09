class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearance_channel'
    return if current_user.nil?

    current_user.notice_status("online")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    return if current_user.nil?

    current_user.logout
    current_user.notice_status("offline")
    # remove_session
  end
end
