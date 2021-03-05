class AddTargetMatchScoreToTournaments < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :target_match_score, :integer, null: false, default: 3
  end
end
