class CreateWarStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :war_statuses do |t|
      t.references :guild, null: false, foreign_key: true
      t.references :war_request, null: false, foreign_key: true
      t.string :position, null: false
      t.integer :no_reply_count, null: false, default: 0
      t.integer :point, default: 0

      t.timestamps
    end
  end
end
