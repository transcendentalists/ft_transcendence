class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war, dependent: :destroy
  has_many :war_statuses, dependent: :destroy
  has_many :guilds, through: :war_statuses
  validates :status, inclusion: { in: ["pending", "accepted", "canceled"] }
  validates :rule_id, inclusion: { in: 1..7 }
  validates :target_match_score, inclusion: { in: [3, 5, 7, 10] }
  validate :end_date_after_start_date
  validate :start_date_after_now

  scope :for_guild_index, -> (guild_id) do
    WarRequest.joins(:war_statuses).where(war_statuses: {guild_id: guild_id, position: "enemy"}, status: "pending")
    .order(start_date: :asc)
    .reject { |request| request.update(status: "canceled") if request.start_date.past? }
    .map { |request|
      challenger_guild_stat = request.war_statuses.find_by_position("challenger")&.guild.profile
      war_request = request.as_json(except: [:start_date, :end_date, :war_time, :rule_id])
      war_request['rule_name'] = request.rule.name
      war_request['start_date'] = request.start_date.strftime("%F")
      war_request['end_date'] = request.end_date.strftime("%F")
      war_request['war_time'] = request.war_time.strftime("%H")
      war_request.merge!( challenger: challenger_guild_stat )
    }
  end

  def can_be_updated_by(user)
    if user.in_guild.nil? ||
      user.in_guild.id != self.war_statuses.find_by_position("enemy").guild.id ||
      user.guild_membership.position == "member"
      return false
    else
      return true
    end
  end

  def enemy
    self.war_statuses.find_by_position("enemy")&.guild
  end

  def challenger
    self.war_statuses.find_by_position("challenger")&.guild
  end

  private
  def start_date_after_now
    if start_date.past?
      errors.add(:start_date, "must be after now")
    end
  end

  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
