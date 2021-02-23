class AddBanEndsAtToGroupChatMemberships < ActiveRecord::Migration[6.1]
  def change
    add_column(:group_chat_memberships, :ban_ends_at, :datetime)
  end
end
