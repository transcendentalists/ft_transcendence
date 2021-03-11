class War < ApplicationRecord
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  has_many :matches, as: :eventable
  has_many :guilds, through: :request
  has_many :war_statuses, through: :request
  validates :status, inclusion: { in: ["pending", "progress", "completed"] }

  def self.for_war_history(guild_id)
    self.where(status: "completed").order(updated_at: :desc).limit(5).map { |war|
      war_statuses = war.war_statuses
      current_guild_war_status = war_statuses.find_by_guild_id!(guild_id)
      enemy_guild_war_status = current_guild_war_status.enemy_status
      {
        point_of_current_guild: current_guild_war_status.point,
        point_of_enemy_guild: enemy_guild_war_status.point,
        enemy_guild_profile: enemy_guild_war_status.guild.profile,
        war_result: war_result(current_guild_war_status, enemy_guild_war_status),
        bet_point: war.request.bet_point
      }
    }
  end

  def self.war_result(current_guild_war_status, enemy_guild_war_status)
    if current_guild_war_status.point > enemy_guild_war_status.point
      "승"
    elsif current_guild_war_status.point == enemy_guild_war_status.point
      current_guild_war_status.enemy? ? "승" : "패"
    else
      "패"
    end
  end
  # private
  # def get_war_index_data(war_id)
  #   war = War.find_by_id(war_id)
  #   request = war.request
  #   my_guild_status = request.war_statuses.find_by_guild_id(params[:guild_id])
  #   opponent_guild_status = my_guild_status.opponent_guild_war_status
  #   status = my_guild_status.for_war_status_view(my_guild_status.guild)
  #   rules_of_war = my_guild_status.request.rules_of_war
  #   matches = my_guild_status.guild.war_match_history
  #   battle = war.battle_data(params[:guild_id].to_i)
  #   keys = %w[guild status rules_of_war matches war battle]
  #   values = [opponent_guild_status.guild.profile, status, rules_of_war, matches, war, battle]
  #   war_index_data = Hash[keys.zip values]
  # end
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

  def index_data!(guild_id)
    my_guild_status = self.request.war_statuses.find_by_guild_id!(guild_id)
    enemy_guild_status = my_guild_status.enemy_status
    status = my_guild_status.for_war_status_view
    rules_of_war = my_guild_status.request.rules_of_war
    matches = my_guild_status.guild.current_war_match_history!
    battle = self.battle_data(guild_id)
    keys = %w[guild status rules_of_war matches war battle]
    values = [enemy_guild_status.guild.profile, status, rules_of_war, matches, self, battle]
    Hash[keys.zip values]
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
    self.update_guild_point
    ActionCable.server.broadcast(
      "war_channel_#{self.id.to_s}",
      {
        type: "war_end",
      },
    )
  end

  def update_guild_point
    bet_point = self.request.bet_point
    winner_guild = self.winner_status.guild
    looser_guild = self.loser_status.guild
    winner_guild.increment!(:point, bet_point)
    looser_guild.decrement!(:point, bet_point)
  end

  def winner_status
    self.loser_status.opponent_guild_war_status
  end

  def loser_status
    max_no_reply_count = self.request.max_no_reply_count
    loser_status = self.war_statuses.find { |status| status.no_reply_count > max_no_reply_count }
    return loser_status unless loser_status.nil?
    return self.war_statuses.find_by_position("challenger") if self.war_statuses.first.point == self.war_statuses.second
    return self.war_statuses.min_by{ |status| status.point }
  end

  def self.retry_set_schedule
    where(status: ["pending", "progress"]).each { |war| war.set_next_schedule }
  end

  def set_next_schedule
    self.set_schedule_at_start_date
    self.set_schedule_at_end_date
    progress_date = self.request.start_date
    end_date = self.request.end_date
    war_time = self.request.war_time.hour
    while progress_date < end_date
      self.set_schedule_at_war_time_start(progress_date.change(hour: war_time))
      self.set_schedule_at_war_time_end(progress_date.change(hour: war_time))
      progress_date += 1.day
    end
  end

  # private
  def job_reservation(until_time, options)
    WarJob.set(wait_until: until_time).perform_later(self, options)
    puts "* Job reservation: #{options[:type]}(id: #{self.id}) at #{until_time}"
  end

  def set_schedule_at_start_date
    self.job_reservation(self.request.start_date, { type: "war_start" })
  end

  def set_schedule_at_end_date
    self.job_reservation(self.request.end_date, { type: "war_end" })
  end

  def set_schedule_at_war_time_start(war_time)
    self.job_reservation(war_time, { type: "war_time_start" })
  end

  def set_schedule_at_war_time_end(war_time)
    self.job_reservation(war_time + 1.hour, { type: "war_time_end" })
  end

  def set_schedule_at_no_reply_time(match)
    # self.job_reservation(Time.zone.now + 10.seconds, { type: "match_no_reply", match: match })
    self.job_reservation(Time.zone.now + 5.minutes, { type: "match_no_reply", match: match })
  end

  def pending_or_progress_battle_exist?
    !self.matches.find_by_status(["pending", "progress"]).nil?
  end
end
