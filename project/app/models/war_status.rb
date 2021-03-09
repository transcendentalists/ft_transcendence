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
  
  def profile(guild_id)
    {
      my_guild_point: self.point,
      opponent_guild_point: WarStatus.opponent_guild_war_status(guild_id).point,
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


end
