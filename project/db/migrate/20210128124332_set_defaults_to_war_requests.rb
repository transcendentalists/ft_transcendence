class SetDefaultsToWarRequests < ActiveRecord::Migration[6.1]
  def change
    change_column_default :war_requests, :bet_point, 200
    change_column_default :war_requests, :max_no_reply_count, 5
    change_column_default :war_requests, :include_ladder, false
    change_column_default :war_requests, :inclued_tournament, false
    change_column_default :war_requests, :status, "pending"
    rename_column :war_requests, :inclued_tournament, :include_tournament
  end
end
