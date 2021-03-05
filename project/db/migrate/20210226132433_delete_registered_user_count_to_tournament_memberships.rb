class DeleteRegisteredUserCountToTournamentMemberships < ActiveRecord::Migration[6.1]
  def change
    remove_column :tournaments, :registered_user_count
  end
end
