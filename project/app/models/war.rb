class War < ApplicationRecord
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  has_many :matches, as: :eventable
  has_many :guilds, through: :request
  has_many :war_statuses, through: :request
  validates :status, inclusion: { in: ["pending", "progress", "completed"] }

  def self.for_war_history!(guild_id)
    self.where(status: "completed").order(updated_at: :desc).limit(5).map { |war|
      war_statuses = war.war_statuses
      current_guild_war_status = war_statuses.find_by_guild_id!(guild_id)
      enemy_guild_war_status = current_guild_war_status.enemy_status
      war_result = war.loser_status.guild.id == guild_id ? "패" : "승"
      {
        point_of_current_guild: current_guild_war_status.point,
        point_of_enemy_guild: enemy_guild_war_status.point,
        enemy_guild_profile: enemy_guild_war_status.guild.profile,
        war_result: war_result,
        bet_point: war.request.bet_point
      }
    }
  end

  def battle_data(guild_id)
    war_match = self.matches.find_by_status(["pending", "progress"])
    is_my_guild_request = war_match.nil? ? nil : war_match.users.first.in_guild.id == guild_id
    wait_time = war_match&.status == "pending" ? (Time.zone.now - war_match.updated_at).to_i : nil
    loading_time = war_match&.start_time.nil? ? nil : (Time.zone.now - war_match.start_time).to_i
    {
      war_status: self.status,
      current_hour: Time.zone.now.hour,
      match: war_match,
      war_time: self.request.war_time.hour,
      is_my_guild_request: is_my_guild_request,
      wait_time: wait_time,
      loading_time: loading_time,
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
    return unless self.status == "pending"
    self.update(status: "progress")
  end

  def end
    return unless self.status == "progress"
    self.update(status: "completed")
    self.update_guild_point
    self.broadcast({ type: "war_end" })
  end

  def update_guild_point
    bet_point = self.request.bet_point
    winner_guild = self.winner_status.guild
    loser_guild = self.loser_status.guild
    winner_guild.increment!(:point, bet_point)
    loser_guild.decrement!(:point, bet_point)
  end

  # 전쟁이 끝나지 않았을 때에도 현재 상황에 따라 이기고/지고 있는 상태를 호출
  # 실제로는 전쟁이 끝난 후에만 사용
  def winner_status
    self.loser_status.enemy_status
  end

  def loser_status
    max_no_reply_count = self.request.max_no_reply_count
    loser_status = self.war_statuses.find { |status| status.no_reply_count > max_no_reply_count }
    return loser_status unless loser_status.nil?
    return self.war_statuses.find_by_position("challenger") if self.war_statuses.same_point?
    return self.war_statuses.min_by{ |status| status.point }
  end

  def pending_or_progress_battle_exist?
    !self.matches.find_by_status(["pending", "progress"]).nil?
  end

  def broadcast(msg)
    ActionCable.server.broadcast("war_channel_#{self.id.to_s}", msg)
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

  def set_schedule_at_no_reply_time(match)
    self.job_reservation(Time.zone.now + 5.minutes, { type: "match_no_reply", match: match })
  end

  private

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

  def job_reservation(until_time, options)
    return if until_time.past?
    WarJob.set(wait_until: until_time).perform_later(self, options)
    puts "* Job reservation: #{options[:type]}(id: #{self.id}) at #{until_time}"
  end
end
