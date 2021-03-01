class Scorecard < ApplicationRecord
  belongs_to :user
  belongs_to :match
  has_one :rule, through: :match

  def ready
    self.update(result: "ready")
  end
end
