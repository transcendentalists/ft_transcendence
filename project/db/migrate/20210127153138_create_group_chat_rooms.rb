class CreateGroupChatRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :group_chat_rooms do |t|
      t.references :owner, null: false, references: :users, foreign_key: { to_table: :users}
      t.string :room_type, null: false
      t.string :title, null: false
      t.integer :max_member_count, null: false, default: 10
      t.integer :current_member_count, null: false, default: 0
      t.string :channel_code, null: false
      t.string :password

      t.timestamps
    end
  end
end
