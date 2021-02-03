class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearance_channel'
    return if current_user.nil?

    current_user.notice_login
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    return if current_user.nil?

    current_user.logout
    current_user.notice_logout
    # remove_session
  end
end
