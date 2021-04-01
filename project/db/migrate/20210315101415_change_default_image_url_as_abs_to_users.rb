class ChangeDefaultImageUrlAsAbsToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :image_url, "/assets/default_avatar.png"
  end
end
