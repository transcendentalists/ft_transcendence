class SetNotNullToWarStatuses < ActiveRecord::Migration[6.1]
  def change
    change_column_null :war_statuses, :point, false
  end
end
