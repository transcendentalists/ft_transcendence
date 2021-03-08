class WarStatus < ApplicationRecord
  belongs_to :guild
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  validates_with WarStatusValidator, on: :create

  def self.current_guild_war_status(current_guild_id)
    self.find_by_guild_id(current_guild_id)
  end

  def self.opponent_guild_war_status(current_guild_id)
    self.where.not(guild_id: current_guild_id).first
  end

  def enemy?
    return self.position == "enemy"
  end

  def challenger?
    return self.position == "challenger"
  end

end
