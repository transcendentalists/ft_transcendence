class AddPositionToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :position, :string, default: "user", null: false
  end
end
