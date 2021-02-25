class Tournament < ApplicationRecord
  belongs_to :rule
  has_many :matches, as: :eventable
  has_many :memberships, class_name: "TournamentMembership"
  has_many :users, through: :memberships, source: :user
  scope :list_not_completed, -> (current_user) do
    tournaments = self.where.not(status: "completed")
    tournaments.map { |tournament|
      stat = tournament.to_simple
      stat.merge({
        rule: {
          id: tournament.rule_id,
          name: tournament.rule.name
        },
        current_user_next_match: tournament.next_match_of(current_user)
      })
    }
  end

  def to_simple
    permitted = %w[id title max_user_count registered_user_count start_date 
                    tournament_time incentive_title incentive_gift status
                    target_match_score]
    stat = self.attributes.filter { |field, value| permitted.include?(field) }
  end

  def next_match_of(current_user)
    membership = self.memberships.find_by_user_id(current_user.id)
    return nil if membership.nil? || membership.completed?

    # membership은 있는데 scorecard가 아직 없다..
    # enemy = {
    #   id: self.next_enemy(current_user)&.id || -1,
    #   name: self.next_enemy(current_user)&.name || "?",
    #   image_url: self.next_enemy(current_user)&.image_url || "assets/default_avatar.png",
    #   anagram: self.next_enemy(current_user)&.anagram || "?"
    # }

    # {
    #   enemy: enemy,
    #   # start_datetime: self.matches.where(status: "pending").start_datetime
    #   tournament_round: membership.result
    # }
    nil
  end

  def next_enemy(current_user)
    matches = self.matches.where(status: "pending")
    return nil if matches.nil?

    matches.each { |match|
      enemy = match.enemy_of(current_user)
      return enemy unless enemy.nil?
    }
  end
end
