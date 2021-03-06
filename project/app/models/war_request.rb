class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war, dependent: :destroy
  has_many :war_statuses, dependent: :destroy
  has_many :guilds, through: :war_statuses
  validates :status, inclusion: { in: ["pending", "accepted", "canceled"], message: "상태를 잘못 입력하셨습니다." }
  validates :rule_id, inclusion: { in: 1..7, message: "요청하신 룰이 존재하지 않습니다." }
  validates :target_match_score, inclusion: { in: [3, 5, 7, 10], message: "목표 점수를 잘못 입력하셨습니다." }
  validates :max_no_reply_count, inclusion: { in: 3..10, message: "최대 미응답 횟수를 잘못 입력하셨습니다." }
  validates :bet_point, inclusion: { in: (100..1000).step(50), message: "배팅 포인트를 잘못 입력하셨습니다."}
  validates_with WarRequestCreateValidator, field: [ :start_date, :end_date, :war_time ], on: :create
  validates_with WarRequestUpdateValidator, field: [ :start_date, :end_date, :war_time ], on: :update

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

  def self.can_be_created_by?(options)
    current_user = options[:current_user]
    guild = options[:guild]
    current_user.in_guild&.id == guild.id && current_user.guild_membership.master?
  end

  def self.create_by!(params)
    guild_id, enemy_guild_id = params.values_at(:guild_id, :enemy_guild_id)
    war_request = self.create(params.except(:guild_id, :enemy_guild_id))
    war_request.create_war_statuses_by_guild_ids!({
      challenger_guild_id: params[:guild_id],
      enemy_guild_id: params[:enemy_guild_id]
    })
    war_request
  end

  def create_war_statuses_by_guild_ids!(options)
    self.war_statuses.create!([
      { guild_id: options[:challenger_guild_id], position: "challenger" },
      { guild_id: options[:enemy_guild_id], position: "enemy" }
    ])
  end

  def can_be_updated_by?(user)
    return false if user.in_guild.nil? || user.guild_membership.position == "member"
    return user.in_guild.id == self.enemy.id
  end

  def enemy
    self.war_statuses.find_by_position("enemy")&.guild
  end

  def challenger
    self.war_statuses.find_by_position("challenger")&.guild
  end

  def rules_of_war
    {
      bet_point: self.bet_point,
      start_date: self.start_date.to_date,
      end_date: self.end_date.to_date,
      rule: self.rule,
      target_match_score: self.target_match_score,
      max_no_reply_count: self.max_no_reply_count,
      war_time: self.war_time.hour,
      include_tournament: self.include_tournament,
      include_ladder: self.include_ladder,
    }
  end
end
