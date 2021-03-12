class WarStatus < ApplicationRecord
  belongs_to :guild
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  validates_with WarStatusValidator, on: :create

  def enemy_status
    war_statuses = self.request.war_statuses
    war_statuses.first == self ? war_statuses.second : war_statuses.first
  end

  def for_war_status_view
    {
      my_guild_point: self.point,
      enemy_guild_point: self.enemy_status.point,
      max_no_reply_count: self.request.max_no_reply_count,
      no_reply_count: self.no_reply_count,
    }
  end

  def enemy?
    return self.position == "enemy"
  end

  def challenger?
    return self.position == "challenger"
  end

  def increase_point
    self.increment!(:point, 20)
  end

  def self.same_point?
    return false unless self.count == 2
    self.first.point == self.second.point
  end
end
