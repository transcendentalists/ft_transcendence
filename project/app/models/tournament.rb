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
      stat = tournament.profile
      stat[:current_user_next_match] = tournament.next_match_of(current_user)
      stat
    }
  end

  def to_simple
    permitted = %w[id title max_user_count registered_user_count start_date 
                    tournament_time incentive_title incentive_gift status
                    target_match_score]
    stat = self.attributes.filter { |field, value| permitted.include?(field) }
  end

  def profile
    stat = self.to_simple
    stat.merge({
      registered_user_count: self.memberships.count,
      rule: {
        id: self.rule_id,
        name: self.rule.name
      },
    })
  end

  def enroll(user)
    if Time.zone.now > self.start_date.midnight
      raise StandardError.new("등록 기간을 초과했습니다.")
    elsif self.memberships.count == self.max_user_count
      raise StandardError.new("정원이 마감되었습니다.")
    elsif self.status != "pending"
      raise StandardError.new("토너먼트가 등록이 불가능한 상태입니다.")
    elsif !self.memberships.find_by_user_id(user.id).nil?
      raise StandardError.new("이미 등록한 토너먼트입니다.")
    elsif self.overlapped_schedule?(user)
      raise StandardError.new("다른 토너먼트 스케쥴과 중복됩니다.")
    end

    TournamentMembership.create!(
      user_id: user.id,
      tournament_id: self.id,
    )
  end

  def match_hour
    self.tournament_time.hour
  end

  def expected_end_date
    self.start_date + ([8,16,32].find_index(self.max_user_count) + 2).days
  end

  def overlapped_schedule?(user)
    !user.tournament_memberships.where(status: ["pending", "progress"]).find { |membership|
      tournament = membership.tournament
      return false if tournament.match_hour != self.match_hour
      (self.start_date.to_i..self.expected_end_date.to_i).each do |date|
        return true if date.between?(tournament.start_date, tournament.expected_end_date)
      end
      false
    }.nil?
  end

  def next_match_of(user)
    membership = self.memberships.find_by_user_id(user.id)
    return nil if membership.nil? || membership.completed?

    match = user.matches.where(status: "pending", eventable_type: "Tournament", eventable_id: self.id).first
    if match.nil?
      {
        enemy: self.class.dummy_enemy,
        start_datetime: self.status == "pending" ? self.first_match_datetime : self.tomorrow_match_datetime,
        tournament_round: self.status == "pending" ? self.max_user_count : self.tomorrow_round
      }
    else
      {
        enemy: match.enemy_of(user).to_simple,
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
    where(status: ["pending", "progress"]).each { |tournament| tournament.set_next_schedule }
  end

  def set_next_schedule
    return if ["completed", "canceled"].include?(self.status)

    if Time.zone.now < self.start_date
      self.set_schedule_at_start_date
    elsif self.match_operation_executed?
      self.set_schedule_at_operation_time
    else
      self.set_schedule_at_tournament_time
    end
  end

  private

  def match_operation_executed?
    Time.zone.now.hour >= self.tournament_time.hour
  end

  def set_schedule_at_operation_time
    TournamentJob.set(wait_until: Date.tomorrow.midnight.change(minute: 5)).perform_later(self)
  end

  def set_schedule_at_tournament_time
    TournamentJob.set(wait_until: Date.today.midnight.change(hour: self.tournament_time.hour)).perform_later(self)
  end

  def set_schedule_at_start_date
    TournamentJob.set(wait_until: self.start_date).perform_later(self)
  end

  def dummy_enemy
    {
      id: -1,
      name: "상대 미정",
      image_url: "assets/default_avatar.png",
    }
  end
end
