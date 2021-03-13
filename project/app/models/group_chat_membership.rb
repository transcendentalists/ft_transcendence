class GroupChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :room, class_name: "GroupChatRoom", foreign_key: "group_chat_room_id"

  def restore!
    room = GroupChatRoom.find(self.group_chat_room_id)
    raise ServiceError(:ServiceUnavailable, "허용 가능 인원을 초과했습니다.") if room.full?
    self.update!(position: "member")
    self.broadcast :restore
    self
  end

  def update_by_params!(options = {by: self, params: {}})
    params = options[:params]
    if !params[:mute].nil? && self.can_be_muted_by?(options[:by])
      self.update_mute!(params[:mute]) 
    end

    position = params[:position]
    return if position.nil?
    raise ServiceError.new(:Forbidden) unless self.can_be_position_changed_by?(options[:by]) 
    raise ServiceError.new(:Forbidden, "챗룸에는 1명 이상의 owner가 필요합니다.") if self.room.only_one_member_exist?

    if position == "owner"
      owner_membership = self.room.memberships.find_by_user_id(self.room.owner.id)
      owner_membership.update_position!("member")
      self.room.update!(owner_id: self.user_id)
    elsif self.position == "owner"
      self.room.make_another_member_owner!
    end
    self.update_position!(position) 
  end

  def can_be_muted_by?(user)
    membership = self.room.memberships.find_by_user_id(user.id)
    return false if membership.nil?
    return false if position_grade[self.position] > position_grade["admin"]

    position_grade[membership.position] >= position_grade["admin"]
  end

  def update_mute!(mute)
    self.update!(mute: mute)
    self.broadcast :mute
    self
  end

  def can_be_position_changed_by?(user)
    return true if user.can_service_manage?

    membership = self.room.memberships.find_by_user_id(user.id)
    return false if membership.nil?
    return false if position_grade[self.position] > position_grade["admin"]

    position_grade[membership.position] >= position_grade["owner"]
  end

  def update_position!(position)
    raise ServiceError.new("이미 해당 유저의 포지션은 #{position}입니다.", 400) if self.position == position

    self.update!(position: position)
    self.boradcst :position
    self
  end
      
  def broadcast(type)
    channel = "group_chat_channel_#{self.group_chat_room_id.to_s}"
    message = { type: type.to_s, user_id: self.user_id }
    message[type] = self[type] if self.has_attribute?(type)
  
    ActionCable.server.broadcast(channel, message)
  end

  def can_be_destroyed_by?(user)
    self.requested_by_myself?(user) || self.can_be_kicked_by?(user)
  end

  def can_be_kicked_by?(user)
    return true if user.can_service_manage?

    user_position = self.room.memberships.find_by_user_id(user.id)&.position
    return false if user_position.nil?
    return false if position_grade[self.position] > position_grade["admin"]

    position_grade[user_position] >= position_grade["admin"]
  end

  def let_out!(options = {by: self.user})
    self.room.with_lock do
      if self.room.active_member_count == 1
        self.room.destroy!
      else
        self.room.make_another_member_owner! if self.position == "owner"
        self.set_ban_time_from_now({ sec: 30 }) unless self.requested_by_myself?(options[:by])
        self.update_position!("ghost")
      end
    end
  end

  def ghost?
    self.position == "ghost"
  end

  def banned?
    !self.ban_ends_at.nil? && self.ban_ends_at > Time.zone.now
  end

  private

  def set_ban_time_from_now(args)
    defaults = { hour: 0, min: 0, sec: 0 }

    time = defaults.merge(args)
    ban_time = time[:hour].hours + time[:min].minutes + time[:sec].seconds
    self.update(ban_ends_at: Time.zone.now + ban_time)
  end
  
  def requested_by_myself?(user)
    self.user_id == user.id
  end
end
