class GroupChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :room, class_name: "GroupChatRoom", foreign_key: "group_chat_room_id"

  def self.deleteChatRoomMembershipOfuser(params)
    self.find_by_group_chat_room_id_and_user_id(
      params[:group_chat_room_id],
      params[:id]
    ).destroy
  end
end
