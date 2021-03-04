class CreateWarRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :war_requests do |t|
      t.references :rule, null: false, foreign_key: true
      t.integer :bet_point, null: false, defaule: 200
      t.timestamp :start_date, null: false
      t.timestamp :end_date, null: false
      t.time :war_time, null: false
      t.integer :max_no_reply_count, null: false, defaule: 5
      t.boolean :include_ladder, null: false, defaule: false
      t.boolean :inclued_tournament, null: false, defaule: false
      t.integer :target_match_score, null: false, defaule: 3
      t.string :status, null: false, defaule: "pending"

      t.timestamps
    end
  end
end
