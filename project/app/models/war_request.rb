class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war, dependent: :destroy
  has_many :war_statuses, dependent: :destroy
  validates :status, inclusion: { in: ["pending", "approved", "canceled"] }

  scope :for_guild_index, -> (guild_id) do
    WarRequest.joins(:war_statuses).where(war_statuses: {guild_id: guild_id, position: "enemy"}, status: "pending").order(start_date: :asc).map { |request| 
      challenger_guild_stat = request.war_statuses.find_by_position("challenger")&.guild.guild_stat
      war_request = request.to_simple
      war_request.merge!( challenger: challenger_guild_stat )
    }
  end

  def to_simple
    permitted = ["id", "bet_point", "war_time"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end
end
