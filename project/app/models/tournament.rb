class Tournament < ApplicationRecord
  belongs_to :rule
  has_many :matches, as: :eventable
  has_many :memberships, class_name: "TournamentMembership"
  has_many :users, through: :memberships, source: :user
  
  def profile
    stat = self.attributes
    stat.merge({
      registered_user_count: self.memberships.count,
      round: self.today_round
      rule: {
        id: self.rule_id,
        name: self.rule.name
      },
    })
  end  
end

