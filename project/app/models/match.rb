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
    .map { |match|
      {
        id: match.id,
        type: match.match_type,
        match: match,
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
    self.update(status: "progress", start_time: Time.now())
  end

  def winner
    self.scorecards.find_by_result("win")
  end

  def cancel
    self.update(status: "canceled")
    self.scorecards.each { |card| card.update(result: "canceled") }
  end
end

