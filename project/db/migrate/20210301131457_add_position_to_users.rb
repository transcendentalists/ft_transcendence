class AddPositionToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :position, :string, default: "user", null: false
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> 62ef8f3cacd915ce1d165bbf93378fd0cdc363d3
