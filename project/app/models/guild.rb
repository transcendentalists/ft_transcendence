class Guild < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, class_name: "GuildMembership"
  has_many :war_statuses
  has_many :requests, through: :war_statuses
  has_many :users, through: :memberships, source: :user
  has_many :invitations, class_name: "GuildInvitation"
  scope :for_guild_index, -> {
    order(point: :desc).map { |guild|
      guild.guild_stat
    }
  }

  scope :for_guild_detail, -> (guild_id, page) {
    find_by_id(guild_id).users.order(point: :desc, name: :asc).page(page).map { |user| 
      user.profile
    }
  }

  def guild_stat
    stat = self.to_simple
    stat[:num_of_member] = self.memberships.count
    stat[:rank] = Guild.order(point: :desc).index(self) + 1
    stat[:owner] = User.find(self.owner_id).name
    stat
  end
  
  def profile
    self.guild_stat
  end

  def to_simple
    permitted = ["id", "name", "anagram", "owner_id", "point", "image_url"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end

end
