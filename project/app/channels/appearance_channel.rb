class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearance_channel'
    current_user.notice_login
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    current_user.logout
    current_user.notice_logout
    # remove_session
  end
end
