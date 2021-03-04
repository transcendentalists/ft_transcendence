class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :rule, null: false, foreign_key: true
      t.references :eventable, null: false, :polymorphic => true
      t.string :match_type, null: false
      t.string :status, default: "pending"
      t.timestamp :start_time
      t.integer :target_score, default: 3

      t.timestamps
    end
  end
end
