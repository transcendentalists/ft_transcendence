class GuildMembership < ApplicationRecord
  belongs_to :user
  belongs_to :guild

  validates :position, inclusion: { in: ["owner", "officer", "member"] }

  def profile
    guild = self.guild.to_simple
    guild['membership_id'] = self.id
    guild['position'] = self.position
    guild
  end

end
