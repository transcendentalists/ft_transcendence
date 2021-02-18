class GroupChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :room, class_name: "GroupChatRoom", foreign_key: "group_chat_room_id"

  def is_authorized_user_to_destroy(current_user)
    self.user_id == current_user.id || authorized_users_to_ban(current_user.id)
  end

  # TODO: web admin도 추가해야함.
  def authorized_users_to_ban(current_user_id)
    owner_id = self.room.owner.id
    return true if owner_id == current_user_id

    room_admin_ids = self.room.memberships.where(position: "admin").pluck(:user_id)
    room_admin_ids.include?(current_user_id) and self.user_id != owner_id
  end
    
  def update_position_as(position)
    self.update(position: position) unless position.nil?
  end
end
