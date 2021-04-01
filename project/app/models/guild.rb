class Guild < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :memberships, class_name: 'GuildMembership', dependent: :destroy
  has_many :war_statuses
  has_many :requests, through: :war_statuses
  has_many :wars, through: :requests
  has_many :users, through: :memberships, source: :user
  has_many :invitations, class_name: 'GuildInvitation'
  has_one_attached :image

  validates :name, uniqueness: { message: "길드 이름은 중복될 수 없습니다." },
  length: { in: 1..10, message: "길드 이름은 최대 10자까지 가능합니다." },
  format: { with: /\A[A-Za-z0-9]+\z/, message: "길드 이름에 특수문자가 포함될 수 없습니다." }
  validates :owner_id, uniqueness: { message: "유저는 하나의 길드만 만들 수 있습니다." }
  validates :anagram, length: { in: 2..5, message: "길드 아나그램은 최대 4자까지 가능합니다." },
  uniqueness: { message: "길드 아나그램은 중복될 수 없습니다." },
  format: { with: /\A@[A-Za-z0-9]+\z/, message: "아나그램에 특수문자가 포함될 수 없습니다." }
  validate :check_anagram

  scope :for_guild_index, -> (page) { order(point: :desc).page(page).map.with_index { |guild, index| guild.profile(index, page) } }

  def check_anagram
    return errors.add(:anagram, message: "아나그램 또는 이름은 비어있을 수 없습니다.") if anagram.nil? || name.nil?
    sorted_anagram = anagram[1..].chars.sort.join
    sorted_name = name.chars.sort.join
    sorted_name.each_char do |ch|
      if sorted_anagram.first == ch
        sorted_anagram.slice!(0)
      end
    end
    return errors.add(:anagram, message: "아나그램은 길드 이름보다 같거나 짧고 이름에 포함된 글자로 구성되어야 합니다.") unless sorted_anagram.empty?
  end

  def for_member_list(page)
    self.users.order(point: :desc, name: :asc).page(page).map { |user|
      user.profile
    }
  end

  def for_user_profile(user)
    simple = self.to_simple
    simple.merge!({
      membership_id: user.guild_membership.id,
      position: user.guild_membership.position,
      in_war: self.in_war?
    })
  end

  def already_request_to?(enemy_guild_id)
    self.requests.where(status: "pending").each do |request|
      return true if request.enemy.id == enemy_guild_id
    end
    false
  end

  def accept_request!(war_request)
    war_request.update!(status: "accepted")
    war_request.enemy.cancel_rest_of_war_request
    war_request.challenger.cancel_rest_of_war_request
    war = War.create!(war_request_id: war_request.id, status: "pending")
    war.set_next_schedule
    war
  end

  def cancel_rest_of_war_request
    self.requests.where(status: "pending").update_all(status: "canceled")
  end

  def current_war_match_history!
    war = self.wars.find_by_status!(["pending", "progress"])
    match_histories = []
    Scorecard.where(user_id: self.users.ids)
    .order(updated_at: :desc).each do |scorecard|
      next if match_histories.length >= 4
      next unless scorecard.with_war?(war.match_types)
      match = scorecard.match
      next if war.created_at > match.updated_at
      match_histories << {
        match: match,
        enemy_guild_user: scorecard.enemy_user,
        current_guild_user_scorecard: scorecard,
        enemy_guild_user_scorecard: scorecard.enemy_scorecard,
      }
    end
    match_histories
  end

  def profile(index = nil, page = nil)
    self.to_simple.merge({
      num_of_member: self.memberships.count,
      rank: self.rank(index, page),
      owner: self.owner.name
    })
  end

  def to_simple
    permitted = %w[id name anagram owner_id point image_url]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end

  def rank(index, page)
    if index.nil?
      Guild.order(point: :desc).index(self) + 1
    else
      (10 * (page - 1)) + index + 1
    end
  end

  def make_another_member_master!
    return if self.memberships.count <= 1

    master = self.owner.guild_membership
    master.update!(position: "member")

    new_master = self.memberships.find_by_position("officer")
    new_master = self.memberships.find_by_position("member") if new_master.nil?
    self.update!(owner_id: new_master.user_id)
    new_master.update!(position: "master")
  end

  def only_one_member_exist?
    self.memberships.reload.count == 1
  end

  def in_war?
    !self.current_war.nil?
  end

  def current_war
    self.wars.find_by_status(["progress", "pending"])
  end

  def master
    self.memberships.find_by_position("master")
  end
end
