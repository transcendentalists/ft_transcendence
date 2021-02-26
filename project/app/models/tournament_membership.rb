class TournamentMembership < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  def completed?
    self.status == "completed"
  end

  def next_match
    tournament = self.tournament
    stat = tournament.to_simple
    stat.merge({
      registered_user_count: tournament.memberships.count,
      rule: {
        id: tournament.rule_id,
        name: tournament.rule.name
      },
      current_user_next_match: tournament.next_match_of(self.user)
    })
  end
end
