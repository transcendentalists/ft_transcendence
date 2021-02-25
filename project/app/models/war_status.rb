class WarStatus < ApplicationRecord
  belongs_to :guild
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"

  def guild_stat
    stat = {}
    stat['guild_id'] = self.guild_id
    stat['profile'] = self.guild.profile
    stat['point'] = self.point
    stat
  end

end
