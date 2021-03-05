class DeleteEndDateToTournaments < ActiveRecord::Migration[6.1]
  def change
    remove_column :tournaments, :end_date
  end
end
