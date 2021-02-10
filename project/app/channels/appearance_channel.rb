class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearance_channel'
    current_user.notice_status("online")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    current_user.logout
    current_user.notice_status("offline")
    # remove_session
  end
end
