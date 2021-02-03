class ChangeDirectChatBansToChatBans < ActiveRecord::Migration[6.1]
  def change
    rename_table :direct_chat_bans, :chat_bans
  end
end
