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
end
