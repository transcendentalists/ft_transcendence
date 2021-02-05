class Match < ApplicationRecord
  belongs_to :rule
  belongs_to :eventable, polymorphic: true, optional: true
  has_many :scorecards, dependent: :delete_all
  has_many :users, through: :scorecards

  def start
    self.update(status: "progress", start_time: Time.now())
  end
end
