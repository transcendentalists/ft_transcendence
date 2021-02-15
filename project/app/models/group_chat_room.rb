class GroupChatRoom < ApplicationRecord
  belongs_to :owner, class_name: "User", :foreign_key => "owner_id"
  has_many :messages, class_name: "ChatMessage", as: :room
  has_many :memberships, class_name: "GroupChatMembership"
  has_many :users, through: :memberships, source: :user
  scope :list_associated_with_current_user, -> (user_id) do
    owner_keys = [:id, :name, :image_url]
    current_user = User.find_by_id(user_id)
    current_user_room_ids = current_user.in_group_chat_room_ids
    current_user_memberships = current_user.group_chat_memberships
    current_user.in_group_chat_rooms.includes(:owner).map { |chatroom| 
      {
          id: chatroom.id,
          title: chatroom.title,
          locked: !chatroom.password.blank?,
          owner: chatroom.owner.slice(*owner_keys),
          max_member_count: chatroom.max_member_count,
          current_member_count: chatroom.users.count,
          current_user_position: current_user_memberships.find_by_group_chat_room_id(chatroom.id).position
      }
    }
  end
  scope :list_filtered_by_type, -> (room_type, current_user_id) {
    owner_keys = [:id, :name, :image_url]
    current_user_room_ids = User.find_by_id(current_user_id).in_group_chat_room_ids
    where(room_type: room_type).where.not(id: current_user_room_ids).map { |chatroom|
      {
        id: chatroom.id,
        title: chatroom.title,
        locked: !chatroom.password.blank?,
        owner: chatroom.owner.slice(*owner_keys),
        max_member_count: chatroom.max_member_count,
        current_member_count: chatroom.users.count,
        current_user_position: nil
      }
    }
  }
  
  def for_chat_room_format
    hash_key_format = [ :id, :room_type, :title, :max_member_count, 
                          :current_member_count, :channel_code ]
    self.slice(*hash_key_format)
  end

  def current_user_info(user)
    current_user_chat_room_membership = self.memberships.find_by_user_id(user.id)

    {
      position: current_user_chat_room_membership.position,
      mute: current_user_chat_room_membership.mute
    }
  end

  def members
    members = []
    self.memberships.each do |member|
      member_hash = User.find_by_id(member.user_id).for_chat_room_format.merge({
        position: member.position,
        mute: member.mute
      })
      members.push(member_hash)
    end
    members
  end

  def is_locked?
    !self.password.blank?
  end

  def is_valid_password?(input_password)
    # BCrypt::Password::new(self.password) == input_password
    self.password == input_password
  end

end
