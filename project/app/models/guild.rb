class Guild < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, class_name: "GuildMembership"
  has_many :war_statuses
  has_many :users, through: :memberships, source: :user
  has_many :invitations, class_name: "GuildInvitation"

  def guild_stat()
    stat = self.to_simple
    stat[:num_of_member] = self.memberships.count
    stat[:rank] = Guild.order(point: :desc).index(self) + 1
    stat[:owner] = User.find(self.owner_id).name
    stat
  end

  def guild_position(user_id)
    stat = {}
    stat[:position] = self.memberships.find(user_id).position
    stat
  end
  
  def profile(user_id)
    stat = self.guild_stat
    stat.merge!(self.guild_position(user_id))
    stat
  end

  def to_simple
    permitted = ["id", "name", "anagram", "owner_id", "point", "image_url"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end

end
