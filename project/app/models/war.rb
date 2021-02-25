class War < ApplicationRecord
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  has_many :matches, as: :eventable
  has_many :guilds, through: :request
  has_many :war_statuses, through: :request
  validates :status, inclusion: { in: ["pending", "progress", "completed"] }

  def self.for_war_history(guild_id)
    self.where(status: "completed").order(updated_at: :desc).limit(5).map { |war|
      enemy_guild = war.enemy_guild(guild_id)
      current_guild_point = war.current_guild_point(guild_id).to_i
      {
        current_guild_point: current_guild_point,
        enemy: enemy_guild.guild_stat,
        war_result: current_guild_point > enemy_guild.point.to_i ? "승" : current_guild_point == enemy_guild.point.to_i ? "무" : "패"
      }
    }
  end

  def current_guild_point(guild_id)
    self.war_statuses.find_by_guild_id(guild_id).point
  end

  def enemy_guild(guild_id)
    self.war_statuses.where.not(guild_id: guild_id).first
  end
end
