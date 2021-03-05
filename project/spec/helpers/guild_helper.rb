module GuildHelper
  def create_guild(options = {owner_id: 1})
    create(:guild, owner_id: options[:owner_id])
  end

  def create_user(options = {name: "noname"})
    create(:user, name: options[:name])
  end

  def create_membership(options = {user_id: 1, guild_id: 1, position: "owner"})
    create(:guild_membership, user_id: options[:user_id], guild_id: options[:guild_id], position: options[:position])
  end
end