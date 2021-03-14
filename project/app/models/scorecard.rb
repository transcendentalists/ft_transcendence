class Scorecard < ApplicationRecord
  belongs_to :user
  belongs_to :match
  has_one :rule, through: :match

  def enemy_user
    self.match.users.where.not(id: self.user_id).first
  end

  def enemy_scorecard
    self.match.scorecards.where.not(user_id: self.user_id).first
  end

  def ready
    self.update(result: "ready")
  end
  
  def with_war?(match_types)
    return false if !self.completed? || self.users.in_same_war?
    match_types.include?(self.match.match_type)
  end

  private

  def completed?
    self.match.status == "completed"
  end
end
