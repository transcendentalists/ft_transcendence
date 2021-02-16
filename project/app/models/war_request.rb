class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war
  has_many :war_statuses

  scope :for_guild_index, -> (guild_id) do
    guild = Guild.find_by_id(guild_id)
    guild.war_statuses.where(guild_id: guild_id).where.not(position: "challenger").map { |war_status|
      war_request = war_status.request.to_simple
      war_request.merge!( enemy: guild.guild_stat )
    }
  end

  def to_simple
    permitted = ["id", "bet_point", "war_time"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end
end
