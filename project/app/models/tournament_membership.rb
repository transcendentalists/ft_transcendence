class TournamentMembership < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  def completed?
    self.status == "completed"
  end
end
