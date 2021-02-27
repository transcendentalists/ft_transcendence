class Tournament < ApplicationRecord
  belongs_to :rule
  has_many :matches, as: :eventable
  has_many :memberships, class_name: "TournamentMembership"
  has_many :users, through: :memberships, source: :user
  has_many :scorecards, through: :matches, as: :eventable
  scope :for_tournament_index, -> (current_user) do
    where.not(status: ["completed", "canceled"])
    .reject{|tournament|
      !tournament.memberships.where(user_id: current_user.id, status: "completed").empty?
    }.map { |tournament|
      stat = tournament.to_simple
      stat.merge({
        registered_user_count: tournament.memberships.count,
        rule: {
          id: tournament.rule_id,
          name: tournament.rule.name
        },
        current_user_next_match: tournament.next_match_of(current_user)
      })
    }
  end

  def self.dummy_enemy
    {
      id: -1,
      name: "?",
      image_url: "assets/default_avatar.png",
    }
  end

  def to_simple
    permitted = %w[id title max_user_count registered_user_count start_date 
                    tournament_time incentive_title incentive_gift status
                    target_match_score]
    stat = self.attributes.filter { |field, value| permitted.include?(field) }
  end

  def next_match_of(current_user)
    membership = self.memberships.find_by_user_id(current_user.id)
    return nil if membership.nil? || membership.completed?

    match = current_user.matches.where(status: "pending", eventable_type: "Tournament", eventable_id: self.id).first
    if match.nil?
      {
        enemy: self.class.dummy_enemy,
        start_datetime: self.status == "pending" ? self.first_match_datetime : self.tomorrow_match_datetime,
        tournament_round: self.status == "pending" ? self.max_user_count : self.tomorrow_round
      }
    else
      {
        enemy: match.enemy_of(current_user).to_simple,
        start_datetime: match.start_time,
        tournament_round: self.today_round
      }
    end
  end

  def first_match_datetime
    d = self.start_date.to_date
    t = self.tournament_time
    DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)
  end

  def tomorrow_match_datetitme
    Time.zone.now.tomorrow.change({ hour: self.tournament_time.hour })
  end

  def today_match_datetime
    Time.zone.now.change({ hour: self.tournament_time.hour })
  end

  def tomorrow_round
    num_of_progress = self.progress_memberships.count / 2 + 1
    [2,4,8,16,32].find { |round| round >= num_of_progress }
  end

  def today_round
    num_of_progress = self.progress_memberships.count
    [2,4,8,16,32].find { |round| round >= num_of_progress } 
  end

  def last_match
    self.matches.order(start_time: :desc).first
  end

  def progress_memberships
    self.memberships.where(status: "progress")
  end

  def update_progress_memberships(params)
    self.progress_memberships.update_all(params)
  end

  def first_date?(datetime)
    datetime.to_date == self.start_date.to_date
  end

  def start
    status = self.memberships.count < 8 ? "canceled" : "progress"
    self.update(status: status)
    self.memberships.update_all(status: status)
  end

  def canceled?
    self.status == "canceled"
  end

  def progress?
    self.status == "progress"
  end

  def winner
    self.memberships.find_by_result("gold")&.user
  end

  def complete
    if !self.winner.nil? && self.incentive_title
      self.winner.update(title: self.incentive_title)
    end
    self.update(status: "completed")
    self.progress_memberships.update_all(status: "completed")
  end

  # 서버 재시작 후 해제된 모든 토너먼트의 스케쥴 재설정(개발 완료 후 주석해제 필요)
  def self.retry_set_schedule
    # where(status: ["pending", "progress"].each { |tournament| tournament.set_next_schedule }
  end

  def set_next_schedule
    return if ["completed", "canceled"].include?(self.status)

    if Time.zone.now < self.start_date
      self.set_schedule_until_start_date
    elsif Time.zone.now.hour >= self.tournament_time.hour
      self.set_schedule_until_operation_time
    else
      self.set_schedule_until_tournament_time
    end
  end

  def set_schedule_until_operation_time
    TournamentJob.set(wait_until: Date.tomorrow.midnight.change(minute: 5)).perform_later(self)
  end

  def set_schedule_until_tournament_time
    TournamentJob.set(wait_until: Date.today.midnight.change(hour: self.tournament_time.hour)).perform_later(self)
  end

  def set_schedule_until_start_date
    TournamentJob.set(wait_until: self.start_date).perform_later(self)
  end

end
