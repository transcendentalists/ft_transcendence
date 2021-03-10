class War < ApplicationRecord
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  has_many :matches, as: :eventable
  has_many :guilds, through: :request
  has_many :war_statuses, through: :request
  validates :status, inclusion: { in: ["pending", "progress", "completed"] }

  def self.for_war_history(guild_id)
    self.where(status: "completed").order(updated_at: :desc).limit(5).map { |war|
      war_statuses = war.war_statuses
      current_guild_war_status = war_statuses.find_by_guild_id(guild_id)
      opponent_guild_war_status = current_guild_war_status.opponent_guild_war_status
      {
        point_of_current_guild: current_guild_war_status.point,
        point_of_opponent_guild: opponent_guild_war_status.point,
        opponent_guild_profile: opponent_guild_war_status.guild.profile,
        war_result: war_result(current_guild_war_status, opponent_guild_war_status),
        bet_point: war.request.bet_point
      }
    }
  end

  def self.war_result(current_guild_war_status, opponent_guild_war_status)
    if current_guild_war_status.point > opponent_guild_war_status.point
      "승"
    elsif current_guild_war_status.point == opponent_guild_war_status.point
      current_guild_war_status.enemy? ? "승" : "패"
    else
      "패"
    end
  end

  def battle_data(guild_id)
    war_match = self.matches.find_by_status(["pending", "progress"])
    is_my_guild_battle_request_to_opponent = war_match.nil? ? nil : war_match.scorecards.first.user.in_guild.id == guild_id
    wait_time = war_match&.status == "pending" ? Time.zone.now - war_match.updated_at : nil
    {
      current_hour: Time.zone.now.hour,
      match: war_match,
      war_time: self.request.war_time.hour,
      is_my_guild_request: is_my_guild_battle_request_to_opponent,
      wait_time: wait_time.to_i,
    }
  end

  def match_types
    match_type = %w[war dual]
    match_type << "ladder" if self.request.include_ladder?
    match_type << "tournament" if self.request.include_tournament?
    match_type
  end

  def start
    self.update(status: "progress")
  end

  def end
    self.update(status: "completed")
  end

  # private
  def job_reservation(until_time, options)
    WarJob.set(wait_until: until_time).perform_later(self, options)
    puts "* Job reservation: #{self.id} at #{until_time}"
  end

  def set_schedule_at_start_date
    self.job_reservation(self.request.start_date, { type: "war_start" })
  end

  def set_schedule_at_end_date
    self.job_reservation(self.request.end_date, { type: "war_end" })
  end

  def set_schedule_at_war_time_start
    self.job_reservation(Time.zone.now.change({ hour: self.request.war_time.hour }), { type: "war_time_start" })
  end

  def set_schedule_at_war_time_end
    self.job_reservation(Time.zone.now.change({ hour: self.request.war_time.hour + 1 }), { type: "war_time_end" })
  end

  def set_schedule_at_no_reply_time(match)
    self.job_reservation(Time.zone.now + 5.minutes, { type: "match_no_reply", match: match })
  end
end
