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
    guild = self.guild&.to_simple
    guild['membership_id'] = self.id
    guild['position'] = self.position
    guild['in_war'] = self.guild.in_war?
    guild
  end

  def can_be_destroyed_by?(user)
    return true if user.can_service_manage?
    return false unless self.guild_id == user.in_guild&.id
    return !self.master? if self.user_id == user.id
    return false if user.guild_membership.position == "member"

    position_compare(user.guild_membership, self) >= 0
  end

  def unregister!
    raise GuildMembershipError.new("길드에는 한명 이상의 유저가 존재해야 합니다.", 403) if self.guild.only_one_member_exist?
    self.guild.make_another_member_master! if self.master?
    self.destroy!
  end

  def can_be_updated_by?(user)
    return true if user.can_service_manage?
    return can_be_destroyed_by?(user) && self.id != user.id
  end

  def master?
    self.position == "master"
  end

  def admin?
    self.position == "admin"
  end

  def update_position!(position, options = { by: self })
    raise GuildMembershipError.new("이미 해당 유저의 포지션은 #{position}입니다.", 400) if self.position == position
    raise GuildMembershipError.new("길드에는 한명의 master가 필요합니다.", 400) if self.guild.only_one_member_exist?
    raise GuildMembershipError.new("접근 권한이 없습니다.", 403) unless self.can_be_updated_by?(options[:by])

    ActiveRecord::Base.transaction do
      if position == "master"
        owner_membership = self.guild.owner.guild_membership
        owner_membership.update!(position: "member")
        self.guild.update!(owner_id: self.user_id)
      elsif self.position == "master"
        self.guild.make_another_member_master!
      end
      self.update!(position: position)
    end
  end

end
