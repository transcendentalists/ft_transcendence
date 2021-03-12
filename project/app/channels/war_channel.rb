class WarChannel < ApplicationCable::Channel
  def subscribed
    stream_from "war_channel_#{params[:war_id].to_s}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # 한 길드의 유저가 전투 버튼을 눌렀을 때에만 호출
  def request_battle(data)
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
