class Guild < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :memberships, class_name: 'GuildMembership'
  has_many :war_statuses
  has_many :requests, through: :war_statuses
  has_many :wars, through: :requests

  has_many :users, through: :memberships, source: :user
  has_many :invitations, class_name: 'GuildInvitation'
  scope :for_guild_index, -> (page) { order(point: :desc).page(page).map.with_index { |guild, index| guild.profile(index, page) } }

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
  
end
