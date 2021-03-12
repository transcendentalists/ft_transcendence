class Match < ApplicationRecord
  belongs_to :rule
  belongs_to :eventable, polymorphic: true, optional: true
  has_many :scorecards, dependent: :delete_all
  has_many :users, through: :scorecards

  validates :rule_id, inclusion: { in: 1..7 }
  validates :target_score, inclusion: { in: [3, 5, 7, 10] }

  scope :for_user_index, -> (user_id) do
    current_user = User.find(user_id)
    where(id: current_user.match_ids, status: "completed").order(created_at: :desc).limit(5).map { |match|
      {
        match: match,
        scorecards: match.scorecards,
        users: match.users
      }
    }
  end

  scope :for_live, -> (match_type) do
    where(match_type: match_type == "ladder" ? ["ladder", "casual_ladder"] : match_type, status: "progress")
    .order(created_at: :desc)
    .filter { |match| Time.zone.now > match.start_time + 10.seconds }
    .map { |match|
      {
        id: match.id,
        type: match.match_type,
        target_score: match.target_score,
        rule: match.rule,
        left_scorecard: match.scorecards[0],
        right_scorecard: match.scorecards[1],
        left_user: match.users[0],
        right_user: match.users[1],
        tournament: match.match_type == "tournament" ? match.eventable.profile : nil,
        guilds: match.match_type == "war" ? match.eventable.guilds : nil,
      }
    }
  end

  def start
    return if self.status != "pending"

    if self.match_type == "tournament"
      ready_count = self.scorecards.reload.where(result: "ready").count
      return self.cancel if ready_count == 0
      return self.end_by_giveup_on_tournament if ready_count == 1
    end
    self.update(status: "progress", start_time: Time.zone.now())
    self.scorecards.update_all(result: "progress")
    self.broadcast({type: "PLAY"})
    self.eventable.broadcast({ type: "start", match_id: self.id, loading_time: 0 }) if (self.match_type == "war")
  end

  # broadcast type
  # 1. PLAY
  # 2. WATCH
  # 3. END
  # 3. ENEMY_GIVEUP
  def broadcast(options = {type: "PLAY", send_id: -1})
    msg = {
      type: options[:type],
      match_id: self.id,
      send_id: options[:send_id] || -1,
    }

    if ["PLAY", "WATCH"].include?(options[:type])
      msg.merge!({
        left: self.left_user.profile,
        right: self.right_user.profile,
        target_score: self.target_score,
        score: {left: self.left_score, right: self.right_score},
        rule: self.rule,
      })
    end

    ActionCable.server.broadcast("game_channel_#{self.id.to_s}", msg)
  end

  def winner
    self.scorecards.find_by_result("win")&.user
  end

  def loser
    self.scorecards.find_by_result("lose")&.user
  end

  def left_user
    self.scorecards.find_by_side('left').user
  end

  def right_user
    self.scorecards.find_by_side('right').user
  end

  def cancel
    self.update(status: "canceled")
    self.scorecards.update_all(result: "canceled")
    self.eventable.broadcast({type: "cancel"}) if self.match_type == "war"
  end

  def end_by_giveup_on_tournament
    self.scorecards.find_by_result("ready").update(result: "win")
    self.scorecards.find_by_result("wait").update(result: "lose")
    self.complete({type: "ENEMY_GIVEUP"})
  end

  def update_points
    self.update_user_point
    self.update_guild_point
  end

  def update_user_point
    return if self.match_type != "ladder"
    self.users.each do |user|
      point = user.id == self.winner.id ? 20 : 5
      user.increment!(:point, point)
    end
  end

  def update_guild_point
    self.users.each do |user|
      point = user.id == self.winner.id ? 20 : 5
      user.in_guild.increment!(:point, point) if user.in_guild?
    end
  end

  def complete(options = {type: "END"})
    if self.users.in_same_war?
      war = self.winner.in_guild.current_war
      war_status = war.war_statuses.find_by_guild_id(self.winner.in_guild.id)
      war_status.increase_point if war.match_types.include?(self.match_type)
    end
    self.update_points
    self.update(status: "completed")
    self.broadcast({type: options[:type]})
    self.eventable.broadcast({type: "end"}) if self.match_type == "war"
  end

  def enemy_of(user)
    self.users.where.not(id: user.id).first
  end

  def canceled?
    self.status == "canceled"
  end

  def pending?
    self.status == "pending"
  end

  def progress?
    self.status == "progress"
  end

  def completed?
    self.status == "completed"
  end

  def completed_or_canceled?
    self.canceled? || self.completed?
  end

  def canceled_or_completed?
    self.completed_or_canceled?
  end

  def player?(user)
    !self.users.where(id: user.id).empty?
  end

  def scorecard_of(user)
    self.scorecards.find_by_user_id(user.id)
  end

  def tournament?
    self.match_type == "tournament"
  end

  def ready_to_start?
    return false if self.tournament? && self.before_tournament_time?
    self.scorecards.reload.where(result: "ready").count == 2
  end

  def loading_end?
    self.status == "progress" && Time.zone.now > self.start_time + 10.seconds
  end

  private

  def before_tournament_time?
    !self.start_time.nil? && Time.zone.now < self.start_time
  end

  def left_score
    self.scorecards.find_by_side("left")&.score || 0
  end

  def right_score
    self.scorecards.find_by_side("right")&.score || 0
  end
end

