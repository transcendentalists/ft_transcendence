class TournamentMembership < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  def next_match
    self.tournament.next_match_of(self.user)
  end

  def completed?
    self.status == "completed"
  end

  def defeated?
    !self.tournament.scorecards.where(user_id: self.user_id, result: "lose").empty?
  end
end
