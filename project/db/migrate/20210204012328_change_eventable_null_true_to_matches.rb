class ChangeEventableNullTrueToMatches < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:matches, :eventable_type, true)
    change_column_null(:matches, :eventable_id, true)
  end
end
