class ConvertPrecisionOfBanEndsAtToGroupChatMemberships < ActiveRecord::Migration[6.1]
  def change
    change_column(:group_chat_memberships, :ban_ends_at, :datetime, precision: 6)
  end
end
