class CreateTournaments < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments do |t|
      t.belongs_to :rule, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :max_user_count, null: false, default: 16
      t.integer :registered_user_count, null: false, default: 0
      t.timestamp :start_date, null: false
      t.timestamp :end_date
      t.time :tournament_time, null: false
      t.string :incentive_title, null: false, default: "super rookie"
      t.string :incentive_gift
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
