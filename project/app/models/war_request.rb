class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war, dependent: :destroy
  has_many :war_statuses, dependent: :destroy
  has_many :guilds, through: :war_statuses
  validates :status, inclusion: { in: ["pending", "accepted", "canceled"], message: "상태를 잘못 입력하셨습니다." }
  validates :rule_id, inclusion: { in: 1..7, message: "요청하신 룰이 존재하지 않습니다." }
  validates :target_match_score, inclusion: { in: [3, 5, 7, 10], message: "목표 점수를 잘못 입력하셨습니다." }
  validates :max_no_reply_count, inclusion: { in: 3..10, message: "최대 미응답 개수를 잘못 입력하셨습니다." }
  validates :bet_point, inclusion: { in: (100..1000).step(50), message: "배팅 포인트를 잘못 입력하셨습니다."}
  validates_with WarRequestValidator, field: [ :start_date, :end_date, :war_time ]

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

  def self.can_be_created_by?(current_user, guild)
    current_user.in_guild&.id == guild.id && current_user.guild_membership.master?
  end

  def can_be_updated_by(current_user)
    if current_user.in_guild.nil? ||
      current_user.in_guild.id != self.war_statuses.find_by_position("enemy").guild.id ||
      current_user.guild_membership.position == "member"
      return false
    else
      return true
    end
  end

  def create_war_statuses!(guild_id, enemy_guild_id)
    self.war_statuses.create!(guild_id: guild_id, position: "challenger")
    self.war_statuses.create!(guild_id: enemy_guild_id, position: "enemy")
  end

  def self.create_by!(params)
    start_date = Time.zone.strptime(params[:start_date], "%Y-%m-%d")
    war_request = self.new(
      rule_id: params[:rule_id],
      bet_point: params[:bet_point],
      start_date: start_date,
      end_date: start_date + params[:war_duration].days,
      war_time: Time.zone.now.change({ hour: params[:war_time] }),
      max_no_reply_count: params[:max_no_reply_count],
      include_ladder: params[:include_ladder],
      include_tournament: params[:include_tournament],
      target_match_score: params[:target_match_score],
    )
    if war_request.invalid?
      @error_message = war_request.errors[war_request.errors.attribute_names.first].first
      raise WarRequestError.new(@error_message)
    end
    war_request.save!
    war_request.create_war_statuses!(params[:guild_id], params[:enemy_guild_id])
    war_request
  end

  def enemy
    self.war_statuses.find_by_position("enemy")&.guild
  end

  def challenger
    self.war_statuses.find_by_position("challenger")&.guild
  end

  private
  def start_date_after_max_end_date
    errors.add(:start_date, "전쟁 시작일은 한달 이내로 설정해야 합니다.") if start_date && start_date > Date.today+ 31.days
  end

  def start_date_after_now
    errors.add(:start_date, "전쟁 시작일은 미래여야 합니다.") if start_date && start_date.past?
  end

  def end_date_after_start_date
    errors.add(:end_date, "전쟁 종료일은 시작일보다 미래여야 합니다.") if start_date && end_date && end_date < start_date
  end
end
