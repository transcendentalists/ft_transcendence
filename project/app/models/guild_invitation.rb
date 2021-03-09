class GuildInvitation < ApplicationRecord
  belongs_to :guild
  belongs_to :user
  belongs_to :invited_user, class_name: "User"
  validates_with GuildInvitationValidator, field: [ :user_id, :invited_user_id, :guild_id ]

  scope :for_user_index, -> (user_id) do
    where(invited_user_id: user_id).order(created_at: :desc).map do |invitation|
      {
        id: invitation.id,
        sender: invitation.user.name,
        receiver: invitation.invited_user.name,
        guild: invitation.guild.to_simple,
      }
    end
  end
end
