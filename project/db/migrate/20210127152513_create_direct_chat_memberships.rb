class CreateDirectChatMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :direct_chat_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :direct_chat_room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
