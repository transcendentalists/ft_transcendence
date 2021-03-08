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
    guild
  end

  def can_be_destroyed_by?(user)
    return true if user.can_service_manage?
    return false unless self.guild_id == current_user.in_guild&.id
    return !self.master? if self.user_id == user.id
    
    grade = ApplicationRecord.position_grade
    return grade[user.guild_membership.position] > grade[self.position] 
  end

  def unregister!
    raise GuildMembershipError.new("길드에는 한명 이상의 유저가 존재해야 합니다.", 403) if self.guild.only_one_member_exist?
    self.guild.make_another_member_master! if self.master?
    self.destroy
  end

  def can_be_updated_by?(current_user)
    return false if self.master?
    return false unless self.guild_id == current_user.in_guild&.id
    return false if current_user.guild_membership.position != "master"
    true
  end

  def master?
    self.position == "master"
  end

  def admin?
    self.position == "admin"
  end
end
