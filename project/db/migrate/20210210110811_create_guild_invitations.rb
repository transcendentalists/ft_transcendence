class CreateGuildInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :guild, null: false, foreign_key: true
      t.references :invited_user, null: false, references: :users, foreign_key: { to_table: :users }
      t.string :result, null: false, default: "pending"
      t.timestamps
    end
  end
end
