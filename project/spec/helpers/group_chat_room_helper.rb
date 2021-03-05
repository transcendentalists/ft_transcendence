module GroupChatRoomHelper
    def create_chatroom(options = {owner: owner})
      owner_id = options[:owner].id
      @chat_room = create(:group_chat_room, owner_id: owner_id)
      @master = create(:group_chat_membership, group_chat_room_id: @chat_room.id, user_id: owner_id, position: "owner")
      @admins = []
      @members = []
      @chat_room
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