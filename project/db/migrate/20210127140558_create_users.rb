class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, unique: true
      t.string :password, null: false
      t.string :intra_id, null: false, unique: true
      t.string :image_url, null: false, default: "default_image_url"
      t.string :title, null: false, default: "beginner"
      t.string :status, null: false, default: "offline"
      t.boolean :two_factor_auth, null: false, default: false
      t.boolean :banned, null: false, default: false

      t.timestamps
    end
  end
end
