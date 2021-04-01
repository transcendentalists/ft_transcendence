class CreateGroupChatMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :group_chat_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group_chat_room, null: false, foreign_key: true
      t.string :position, null: false, default: "member"
      t.boolean :mute, null: false, default: false

      t.timestamps
    end
  end
end
