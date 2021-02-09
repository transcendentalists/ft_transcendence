class Match < ApplicationRecord
  belongs_to :rule
  belongs_to :eventable, polymorphic: true, optional: true
  has_many :scorecards, dependent: :delete_all
  has_many :users, through: :scorecards

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
