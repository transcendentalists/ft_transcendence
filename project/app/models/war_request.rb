class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war, dependent: :destroy
  has_many :war_statuses, dependent: :destroy
  validates :status, inclusion: { in: ["pending", "approved", "canceled"] }
  validates :rule_id, inclusion: { in: 1..7 }
  validates :target_match_score, inclusion: { in: [3, 5, 7, 10] }
  # validates_datetime :end_date, after: :start_date
  # validates_datetime :start_date, after: DateTime.now()

  scope :for_guild_index, -> (guild_id) do
    WarRequest.joins(:war_statuses).where(war_statuses: {guild_id: guild_id, position: "enemy"}, status: "pending").order(start_date: :asc).map { |request| 
      challenger_guild_stat = request.war_statuses.find_by_position("challenger")&.guild.profile

      # war_request.start_date = request.start_date.strftime("%F")
      # war_request.end_date = request.end_date .strftime("%F")
      # war_request.war_time = request.war_time.strftime("%H")
      
      war_request = request.as_json(except: [:start_date, :end_date, :war_time])
      war_request['start_date'] = request.start_date.strftime("%F")
      war_request['end_date'] = request.end_date.strftime("%F")
      war_request['war_time'] = request.war_time.strftime("%H")
      war_request.merge!( challenger: challenger_guild_stat )
    }
  end
end