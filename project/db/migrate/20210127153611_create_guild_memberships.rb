class CreateGuildMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :guild, null: false, foreign_key: true
      t.string :position, null: false, default: "member"

      t.timestamps
    end
  end
end
