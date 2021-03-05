class ChangeAnotherDefaultImageUrlToGuilds < ActiveRecord::Migration[6.1]
  def change
    change_column_default :guilds, :image_url, "assets/default_guild.png"
  end
end
