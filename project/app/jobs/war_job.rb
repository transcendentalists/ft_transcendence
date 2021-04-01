class WarJob < ApplicationJob
  queue_as :default

  def perform(war, options)
    begin
      @war = war
      @options = options
      type = options[:type]
  
      case type
      when "war_start" then @war.start
      when "war_end" then @war.end
      when "war_time_start" then war_time_start
      when "war_time_end" then war_time_end
      when "match_no_reply" then match_no_reply
      end      
    rescue => e
      put "[ERROR][WarJob_#{@war.id}] #{e.message}"
    end
  end

  def war_time_start
    return unless @war.status == "progress"
    @war.broadcast({ type: "war_time_start", current_hour: Time.zone.now.hour })
  end

  def war_time_end
    return unless @war.status == "progress"
    @war.broadcast({ type: "war_time_end", current_hour: Time.zone.now.hour })
  end

  def match_no_reply
    match = @options[:match]
    return unless match.pending?
    waiting_user = match.scorecards.first.user
    no_reply_guild_war_status = @war.war_statuses.where.not(guild_id: waiting_user.in_guild.id).first
    no_reply_guild_war_status.no_reply_count += 1
    no_reply_guild_war_status.save!
    @war.end if no_reply_guild_war_status.no_reply_count > @war.request.max_no_reply_count
    match.cancel
    @war.broadcast({ type: "no_reply", user_id: waiting_user.id })
  end
end
