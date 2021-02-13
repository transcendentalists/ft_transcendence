class GroupChatRoom < ApplicationRecord
  belongs_to :owner, class_name: "User", :foreign_key => "owner_id"
  has_many :messages, class_name: "ChatMessage", as: :room
  has_many :memberships, class_name: "GroupChatMembership"
  has_many :users, through: :memberships, source: :user
  scope :list_associated_with_current_user, -> (user_id) do
    owner_keys = [:id, :name, :image_url]
    current_user_room_ids = User.find_by_id(user_id).in_group_chat_room_ids
    current_user = User.find_by_id(user_id)
    current_user_memberships = current_user.group_chat_memberships
    current_user.in_group_chat_rooms.includes(:owner).map { |chatroom| 
      {
          id: chatroom.id,
          title: chatroom.title,
          locked: chatroom.password.nil?,
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
        locked: chatroom.password.nil?,
        owner: chatroom.owner.slice(*owner_keys),
        max_member_count: chatroom.max_member_count,
        current_member_count: chatroom.users.count,
        current_user_position: nil
      }
    }
  }

  def current_user_position(current_user_id)
    "normal member"
  end

end
