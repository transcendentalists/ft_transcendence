class War < ApplicationRecord
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  has_many :matches, as: :eventable
  has_many :guilds, through: :request
  has_many :war_statuses, through: :request
  validates :status, inclusion: { in: ["pending", "progress", "completed"] }

  def self.for_war_history(guild_id)
    self.where(status: "completed").order(updated_at: :desc).limit(5).map { |war|
      war_statuses = war.war_statuses
      current_guild_war_status = war_statuses.find_by_guild_id(guild_id)
      enemy_guild_war_status = current_guild_war_status.enemy_guild_war_status
      {
        point_of_current_guild: current_guild_war_status.point,
        point_of_enemy_guild: enemy_guild_war_status.point,
        enemy_guild_profile: enemy_guild_war_status.guild.profile,
        war_result: war_result(current_guild_war_status, enemy_guild_war_status),
        bet_point: war.request.bet_point
      }
    }
  end

  def self.war_result(current_guild_war_status, enemy_guild_war_status)
    if current_guild_war_status.point > enemy_guild_war_status.point
      "승"
    elsif current_guild_war_status.point == enemy_guild_war_status.point
      current_guild_war_status.enemy? ? "승" : "패"
    else
      "패"
    end
  end
end
