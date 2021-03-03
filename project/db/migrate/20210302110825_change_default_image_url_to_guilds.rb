class ChangeDefaultImageUrlToGuilds < ActiveRecord::Migration[6.1]
  def change
    change_column_default :guilds, :image_url, "assets/lee.png"
  end
end
