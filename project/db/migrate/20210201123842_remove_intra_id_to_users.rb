class RemoveIntraIdToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :intra_id
  end
end
