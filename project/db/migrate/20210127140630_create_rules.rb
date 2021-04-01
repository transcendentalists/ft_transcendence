class CreateRules < ActiveRecord::Migration[6.1]
  def change
    create_table :rules do |t|
      t.string :name, null: false, default: "basic"
      t.boolean :invisible, null: false, default: false
      t.boolean :dwindle, null: false, default: false
      t.boolean :accel_wall, null: false, default: false
      t.boolean :accel_paddle, null: false, default: false
      t.boolean :bound_wall, null: false, default: false
      t.boolean :bound_paddle, null: false, default: false

      t.timestamps
    end
  end
end
