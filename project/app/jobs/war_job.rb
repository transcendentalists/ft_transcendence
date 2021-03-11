class WarJob < ApplicationJob
  queue_as :default

  def perform(war, options)
    @war = war
    @type = options[:type]
    @options = options

    case @type
    when "war_start" then war_start
    when "war_end" then war_end
    when "war_time_start" then war_time_start
    when "war_time_end" then war_time_end
    when "match_no_reply" then match_no_reply
    end
  end

  def war_start
    @war.start
  end

  def war_end
    return unless @war.status == "progress"
    @war.end
  end

  def war_time_start
    return unless @war.status == "progress"
    broadcast_to_war_channel("war_time_start")
  end

  def war_time_end
    return unless @war.status == "progress"
    broadcast_to_war_channel("war_time_end")
  end

  def match_no_reply
    match = @options[:match]
    return unless match.pending?
    waiting_user = match.scorecards.first.user
    no_reply_guild_war_status = @war.war_statuses.where.not(guild_id: waiting_user.in_guild.id).first
    no_reply_guild_war_status.no_reply_count += 1
    no_reply_guild_war_status.save
    @war.end if no_reply_guild_war_status.no_reply_count > @war.request.max_no_reply_count
    match.cancel
    broadcast_to_war_channel("no_reply")
  end

  def broadcast_to_war_channel(type)
    ActionCable.server.broadcast(
      "war_channel_#{@war.id.to_s}",
      {
        type: type,
        current_hour: Time.zone.now.hour,
      },
    )
  end
end
