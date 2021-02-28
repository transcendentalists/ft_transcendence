class Tournament < ApplicationRecord
  belongs_to :rule
  has_many :matches, as: :eventable
  has_many :memberships, class_name: "TournamentMembership"
  has_many :users, through: :memberships, source: :user
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
      name: "상대 미정",
      image_url: "assets/default_avatar.png",
    }
  end

  def to_simple
    permitted = %w[id title max_user_count registered_user_count start_date 
                    tournament_time incentive_title incentive_gift status
                    target_match_score]
    stat = self.attributes.filter { |field, value| permitted.include?(field) }
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
    end

    TournamentMembership.create!(
      user_id: user.id,
      tournament_id: self.id,
    )
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
    Time.zone.now.tomorrow.change({ hour: self.tournament_time.hour, min: 0, sec: 0})
  end

  def tomorrow_round
    num_of_progress = self.memberships.where(status: "progress").count / 2 + 1
    [2,4,8,16,32].find { |round| round >= num_of_progress }
  end

  def today_round
    num_of_progress = self.memberships.where(status: "progress").count
    [2,4,8,16,32].find { |round| round >= num_of_progress } 
  end

end
