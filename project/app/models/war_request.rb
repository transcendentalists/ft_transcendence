class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war, dependent: :destroy
  has_many :war_statuses, dependent: :destroy

  scope :for_guild_index, -> (guild_id) do
    guild = Guild.find_by_id(guild_id)
    guild.war_statuses.where(guild_id: guild_id, position: "enemy").map { |war_status|
      challenger_guild_id = WarStatus.find_by_war_request_id_and_position(war_status.war_request_id, "challenger").guild_id
      war_request = war_status.request.to_simple
      war_request.merge!( challenger: Guild.find_by_id(challenger_guild_id).guild_stat )
    }
  end

  def to_simple
    permitted = ["id", "bet_point", "war_time"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end
end
