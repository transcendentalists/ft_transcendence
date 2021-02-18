class GroupChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :room, class_name: "GroupChatRoom", foreign_key: "group_chat_room_id"

  def can_be_destroyed_by?(current_user)
    self.user_id == current_user.id || can_be_kicked_by?(current_user.position)
  end

  def can_be_muted_by?(current_user_position)
    position_grade = ApplicationRecord.position_grade
    position_grade[self.position] <= 2 && position_grade[current_user_position] >= 2
  end

  def can_be_position_changed_by?(current_user_position)
    position_grade = ApplicationRecord.position_grade
    position_grade[self.position] <= 2 && position_grade[current_user_position] >= 3
  end

  def can_be_kicked_by?(current_user_position)
    position_grade = ApplicationRecord.position_grade
    position_grade[self.position] <= 2 && position_grade[current_user_position] >= 2
  end
      
  def ghost?
    self.position == "ghost"
  end

  def restore
    self.update(position: "member")
    self
  end

  def update_mute(mute)
    self.update!(mute: mute)
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

  def update_position(position)
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
end
