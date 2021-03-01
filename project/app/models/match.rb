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

  def start
    return if self.status != "pending"
    
    if self.match_type == "tournament"
      return self.cancel if self.scorecards.where(status: "ready").count != 2
      self.update(status: "progress")
    else 
      self.update(status: "progress", start_time: Time.now())
    end
  end

  def winner
    self.scorecards.find_by_result("win")&.user
  end

  def loser
    self.scorecards.find_by_result("lose")&.user
  end

  def cancel
    self.update(status: "canceled")
    self.scorecards.each { |card| card.update(result: "canceled") }
  end

  def enemy_of(user)
    self.users.where.not(id: user.id).first
  end

  def canceled?
    self.status == "canceled"
  end

  def completed?
    self.status == "completed"
  end

  def completed_or_canceled?
    self.canceled? || self.completed?
  end

  def canceled_or_canceled?
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

  def early_time?
    !self.start_time.nil? && Time.zone.now < self.start_time
  end

  def ready?
    if self.tournament? && self.early_time?
      false
    elsif self.scorecards.count < 2 || !self.scorecards.reload.where(result: "wait")reload.find_by_result("wait").nil?

  end
end

