class War < ApplicationRecord
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  has_many :matches, as: :eventable
  scope :for_guild_detail, -> (guild_id) do
    Guild.find_by_id(guild_id).requests.where(status: "completed").order(end_date: :desc).limit(5).map { |request|
      my_guild_status = request.war_statuses.where(guild_id: guild_id).first
      enemy_guild_status = request.war_statuses.where.not(guild_id: guild_id).first
      {
        my_guild_point: my_guild_status.point,
        enemy_guild_id: enemy_guild_status.guild_id,
        enemy_guild_point: enemy_guild_status.point,
        enemy_guild_profile: Guild.find_by_id(enemy_guild_status.guild_id).profile,
        war_result: my_guild_status.point.to_i > enemy_guild_status.point.to_i ? "승" : "패",
      }
    }
  end
end
