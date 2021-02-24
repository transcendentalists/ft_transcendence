class GuildMembership < ApplicationRecord
  belongs_to :user
  belongs_to :guild

  validates :position, inclusion: { in: ["master", "officer", "member"] }

  def profile
    guild = self.guild.to_simple
    guild['membership_id'] = self.id
    guild['position'] = self.position
    guild
  end

  def can_be_destroyed_by?(current_user)
    if current_user.guild_membership.guild_id != self.guild_id || (
      current_user.id != self.user_id &&
      current_user.guild_membership.position == "member"
    )
      false
    else true
    end
  end

end
