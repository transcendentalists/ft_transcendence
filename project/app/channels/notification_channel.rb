class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel_#{params[:room_id].to_s}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def dual_request(data)
    ActionCable.server.broadcast(
      "notification_channel_#{data['id'].to_s}",
      {
        type: 'dual',
        status: 'request',
        profile: current_user.profile,
        rule_id: data['rule_id'],
        rule_name: data['rule_name'],
        target_score: data['target_score'],
      },
    )
  end

  def dual_declined(challenger)
    ActionCable.server.broadcast(
      "notification_channel_#{challenger['id'].to_s}",
      { type: 'dual', status: 'declined' },
    )
  end

  def dual_cancel(enemy)
    ActionCable.server.broadcast(
      "notification_channel_#{enemy['id'].to_s}",
      { type: 'dual', status: 'canceled' },
    )
  end

  def dual_request_already_exist(challenger)
    ActionCable.server.broadcast(
      "notification_channel_#{challenger['id'].to_s}",
      { type: 'dual', status: 'exist' },
    )
  end
end
