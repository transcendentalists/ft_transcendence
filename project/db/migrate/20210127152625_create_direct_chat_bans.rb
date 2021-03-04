class CreateDirectChatBans < ActiveRecord::Migration[6.1]
  def change
    create_table :direct_chat_bans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :banned_user, null: false, references: :users, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
