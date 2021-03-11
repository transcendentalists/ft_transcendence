module GroupChatRoomHelper
    def create_chat_room(options = {owner: owner})
      owner_id = options[:owner].id
      @chat_room = create(:group_chat_room, owner_id: owner_id)
      @owner = create(:group_chat_membership, group_chat_room_id: @chat_room.id, user_id: owner_id, position: "owner")

      @members = create_list(:user, options[:register])
      @members.each { |member|
        GroupChatMembership.create(user_id: member.id, group_chat_room_id: @chat_room.id)
      }

      create(:chat_message, user_id: owner_id, room_type: "GroupChatRoom", room_id: @chat_room.id)
      @admins = []
      @chat_room
    end
  end