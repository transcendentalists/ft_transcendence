class WarChannel < ApplicationCable::Channel
  def subscribed
    stream_from "war_channel_#{params[:room_id].to_s}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def battle_request(data)
    ActionCable.server.broadcast(
      "war_channel_#{data['war_id'].to_s}",
      {
        type: "request",
        guild_id: data["guild_id"],
        match_id: data["match_id"],
      },
    )
  end
end
