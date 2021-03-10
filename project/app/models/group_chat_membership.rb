class GroupChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :room, class_name: "GroupChatRoom", foreign_key: "group_chat_room_id"

  def current_user?(user)
    self.user_id == user.id
  end

  def requested_by_myself?(current_user)
    self.user_id == current_user.id
  end

  def can_be_destroyed_by?(current_user)
    return requested_by_myself?(current_user) || can_be_kicked_by?(current_user)
  end

  def can_be_kicked_by?(user)
    return true if user.can_service_manage?

    user_position = self.room.memberships.find_by_user_id(user.id)&.position
    return false if user_position.nil?
    return false if position_grade[self.position] > position_grade["admin"]

    position_grade[user_position] >= position_grade["admin"]
  end

  def can_be_muted_by?(user)
    membership = self.room.memberships.find_by_user_id(user.id)
    return false if membership.nil?
    return false if position_grade[self.position] > position_grade["admin"]

    position_grade[membership.position] >= position_grade["admin"]
  end

  def can_be_position_changed_by?(user)
    return true if user.can_service_manage?

    membership = self.room.memberships.find_by_user_id(user.id)
    return false if membership.nil?
    return false if position_grade[self.position] > position_grade["admin"]

    position_grade[membership.position] >= position_grade["owner"]
  end
      
  def ghost?
    self.position == "ghost"
  end

  def banned?
    !self.ban_ends_at.nil? && self.ban_ends_at > Time.now
  end

  def restore
    room = GroupChatRoom.find_by_id(self.group_chat_room_id)
    return nil if room.active_member_count == room.max_member_count
    self.update!(position: "member")
    ActionCable.server.broadcast(
      "group_chat_channel_#{self.group_chat_room_id.to_s}",
      {
        type: "restore",
        user_id: self.user_id,
      }
    )
    self
  end

  def update_by_params!(options = {by: self, params: {}})
    params = options[:params]
    unless params[:mute].nil?
      self.update_mute!(params[:mute]) if self.can_be_muted_by?(options[:by])
    end

    position = params[:position]
    return if position.nil?
    raise GroupChatMembershipError.new("포지션 변경 권한이 없습니다.", 403) unless self.can_be_position_changed_by?(options[:by]) 
    raise GroupChatMembershipError.new("챗룸에는 1명 이상의 owner가 필요합니다.", 403) if self.room.only_one_member_exist?

    if position == "owner"
      owner_membership = self.room.memberships.find_by_user_id(self.room.owner.id)
      owner_membership.update_position!("member")
      self.room.update!(owner_id: self.user_id)
    elsif self.position == "owner"
      self.room.make_another_member_owner!
    end
    self.update_position!(position) 
  end

  def update_mute!(mute)
    self.update!(mute: mute)
    ActionCable.server.broadcast(
      "group_chat_channel_#{self.group_chat_room_id.to_s}",
      {
        type: "mute",
        user_id: self.user_id,
        mute: self.reload.mute
      }
    )
    self
  end

  def update_position!(position)
    raise GroupChatMembershipError.new("이미 해당 유저의 포지션은 #{position}입니다.", 400) if self.position == position

    self.update!(position: position)
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

  def set_ban_time_from_now(args)
    defaults = { hour: 0, min: 0, sec: 0 }

    time = defaults.merge(args)
    ban_time = time[:hour].hours + time[:min].minutes + time[:sec].seconds
    self.update(ban_ends_at: Time.now + ban_time)
  end
end
