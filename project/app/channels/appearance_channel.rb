class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'appearance_channel'
    #  current_user -> 초기화 서버에 나 연결됐어
    p 'subscribed'
    p 'subscribed'
    p 'subscribed'
    p 'subscribed'
    p 'current_user: '
    p current_user
    return if current_user.nil?

    current_user.notice_login
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
