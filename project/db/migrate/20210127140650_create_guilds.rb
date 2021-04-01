class CreateGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table :guilds do |t|
      t.references :owner, null: false, unique: true, references: :users, foreign_key: { to_table: :users }
      t.string :name, null: false, unique: true
      t.string :anagram, null: false, unique: true
      t.string :image_url, default: "default_image_url"
      t.integer :point, null: false, default: 0

      t.timestamps
    end
  end
end
