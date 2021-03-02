class Guild < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :memberships, class_name: 'GuildMembership'
  has_many :war_statuses
  has_many :requests, through: :war_statuses
  has_many :wars, through: :requests
  has_many :users, through: :memberships, source: :user
  has_many :invitations, class_name: 'GuildInvitation'
  scope :for_guild_index, -> (page) { order(point: :desc).page(page).map.with_index { |guild, index| guild.profile(index, page) } }
  has_one_attached :image
  validates :name, uniqueness: { message: "길드 이름은 중복될 수 없습니다." }
  validates :owner_id, uniqueness: { message: "유저는 하나의 길드만 만들 수 있습니다." }
  validates :anagram, uniqueness: { message: "길드 아나그램은 중복될 수 없습니다." }
  validates :name, length: { in: 1..10, too_long: '길드 이름은 최대 10자까지 가능합니다.' } , allow_blank: true
  validate :check_anagram

  def check_anagram
    return errors.add(:anagram, :invalid, message: "아나그램은 1글자에서 4글자로 입력해 주시길 바랍니다.") unless (2..5).include?(anagram.length)
    return errors.add(:anagram, :invalid, message: "아나그램에 특수문자가 포함될 수 없습니다.") unless anagram.match(/^@[A-Za-z0-9]/)
    anagram_downcase = anagram.downcase
    anagram_downcase.slice!(0)
    name.each_char do |name_char|
      anagram_downcase.slice!(0) if name_char.downcase == anagram_downcase.first
    end
    return errors.add(:anagram, :invalid, message: "아나그램은 길드 이름에 포함된 단어로 구성되어야 합니다.") unless anagram_downcase.empty?
  end

  def for_member_list(page)
    self.users.order(point: :desc, name: :asc).page(page).map { |user|
      user.profile
    }
  end

  def profile(index = nil, page = nil)
    guild = self.to_simple
    guild[:num_of_member] = self.memberships.count
    guild[:rank] = index.nil? ? Guild.order(point: :desc).index(self) + 1 : (10 * (page - 1)) + index + 1
    guild[:owner] = self.owner.name
    guild
  end

  def to_simple
    permitted = %w[id name anagram owner_id point image_url]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end

  def in_war?
    !self.wars.find_by_status(["progress", "pending"]).nil?
  end

  def cancel_rest_of_war_request
    self.requests.where(status: "pending").update_all(status: "canceled")
  end

  def accept(war_request)
    war_request.update(status: "accepted")
    war_request.enemy.cancel_rest_of_war_request
    war_request.challenger.cancel_rest_of_war_request
    War.create(war_request_id: war_request.id, status: "pending")
  end

  def create_membership(user_id, position)
    GuildMembership.create(user_id: user_id, guild_id: self.id, position: position)
  end
end
