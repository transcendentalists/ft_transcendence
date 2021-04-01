class SetDefaultsNullEventableToMatches < ActiveRecord::Migration[6.1]
  def change
    change_column :matches, :eventable_type, :string, optional: true
    change_column :matches, :eventable_id, :bigint, optional: true
  end
end
