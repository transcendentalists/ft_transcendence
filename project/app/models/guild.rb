class Guild < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :memberships, class_name: 'GuildMembership'
  has_many :war_statuses
  has_many :requests, through: :war_statuses

  has_many :users, through: :memberships, source: :user
  has_many :invitations, class_name: 'GuildInvitation'
  scope :for_guild_index, -> (page) { order(point: :desc).page(page.to_i).map.with_index { |guild, index| guild&.profile(index, page.to_i) } }

  def profile(index = nil, page = nil)
    guild = self.to_simple
    guild[:num_of_member] = self.memberships.count
    index.nil? ? guild[:rank] = Guild.order(point: :desc).index(self) + 1 : guild[:rank] = (10 * (page - 1)) + index + 1
    guild[:owner] = self.owner.name
    guild
  end

  def to_simple
    permitted = %w[id name anagram owner_id point image_url]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end
end
