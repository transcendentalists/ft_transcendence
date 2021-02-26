class GuildMembership < ApplicationRecord
  belongs_to :user
  belongs_to :guild

  validates :position, inclusion: { in: ["master", "officer", "member"] }

  def self.priority_order
    self.order(
      Arel.sql(<<-SQL.squish
      CASE
        WHEN position = 'master' THEN '1'
        WHEN position = 'officer' THEN '2'
        WHEN position = 'member' THEN '3'
      END
    SQL
    )
  )
  end

  def self.for_members_ranking(guild_id, page)
    self.where(guild_id: guild_id).priority_order.page(page).map { |membership|
      membership.user.profile
    }
  end

  def profile
    guild = self.guild.to_simple
    guild['membership_id'] = self.id
    guild['position'] = self.position
    guild
  end

  def can_be_destroyed_by?(current_user)
    return false if self.master?
    return true if self.requested_by_me?(current_user.id)
    return false unless current_user.member_of_guild?(self.guild_id)
    return false if current_user.guild_membership.position == "member"
    true
  end

  def can_be_updated_by?(current_user)
    return false if self.master?
    return false unless current_user.member_of_guild?(self.guild_id)
    true
  end

  def requested_by_me?(user_id)
    self.user_id == user_id
  end

  def master?
    self.position == "master"
  end
end
