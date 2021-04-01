class CreateScorecards < ActiveRecord::Migration[6.1]
  def change
    create_table :scorecards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.string :side, null: false
      t.integer :score, null: false, default: 0
      t.string :result, null: false, default: "wait"

      t.timestamps
    end
  end
end
