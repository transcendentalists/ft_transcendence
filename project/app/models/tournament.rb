class Tournament < ApplicationRecord
  belongs_to :rule
  has_many :matches, as: :eventable
  has_many :memberships, class_name: "TournamentMembership"
  has_many :users, through: :memberships, source: :user

  def progress_memberships
    self.memberships.where(status: "progress")
  end
  
  def today_round
    num_of_progress = self.progress_memberships.count
    [2,4,8,16,32].find { |round| round >= num_of_progress } 
  end
  
  #TODO: tournament_round: self.today_round로 PR시 변경
  def profile
    stat = self.attributes
    stat.merge({
      registered_user_count: self.memberships.count,
      round: ["2", "4", "8", "16", "32"][rand(5)],
      rule: {
        id: self.rule_id,
        name: self.rule.name
      },
    })
  end  
end

