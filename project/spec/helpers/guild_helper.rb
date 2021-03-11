module GuildHelper
  def create_guild(options = {owner: owner, name: "dummy", anagram: "@dum", point: 1500})
    owner_id = options[:owner].id
    name = options[:name]
    anagram = options[:anagram]
    point = options[:point]
    @guild = create(:guild, owner_id: owner_id, name: name, anagram: anagram, point: point)
    @master = create(:guild_membership, guild_id: @guild.id, user_id: owner_id, position: "master")
    @officers = []
    @members = []
    @guild
  end

  def create_officer
    user = create(:user)
    officer = create(:guild_membership, guild_id: @guild.id, user_id: user.id, position: "officer")
    @officers.append(officer)
    officer
  end

  def create_members(numbers)
    users = create_list(:user, numbers)
    users.each do |user|
      @members.append(create(:guild_membership, guild_id: @guild.id, user_id: user.id), position: "member")
    end
    @members
  end

  def create_membership(options = {user_id: 1, guild_id: 1, position: "master"})
    create(:guild_membership, user_id: options[:user_id], guild_id: options[:guild_id], position: options[:position])
  end
end
