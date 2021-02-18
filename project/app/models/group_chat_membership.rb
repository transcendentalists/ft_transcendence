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
  
  def self.updateChatRoomMembership(params)
    return nil if params.nil?
    member_membership = params[:member_membership]
    if params[:mute] && member_membership.position != "owner"
      member_membership.mute = params[:mute]
    end
    return nil if member_membership.save == false
    member_membership.update_position if params[:position]
    member_membership
  end

  def update_mute(params)
    return nil if params[:mute].nil? || self.position == "owner"
    self.mute = params[:mute]
    return nil if save == false
    ActionCable.server.broadcast(
      "group_chat_channel_#{self.group_chat_room_id.to_s}",
      {
        type: "mute",
        user_id: self.user_id,
        mute: self.mute
      }
    )
    self
  end

  def update_position(params)
    return nil if params[:position].nil?
    return nil if params[:admin_membership].position != "owner"
    self.position = params[:position]
    return nil if save == false
    ActionCable.server.broadcast(
      "group_chat_channel_#{self.group_chat_room_id.to_s}",
      {
        type: "position",
        user_id: self.user_id,
        position: self.position
      }
    )
    self
  end

end
