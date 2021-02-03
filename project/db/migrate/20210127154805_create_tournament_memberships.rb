class CreateTournamentMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :tournament_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.string :result, null: false, default: "cooper"

      t.timestamps
    end
  end
end
