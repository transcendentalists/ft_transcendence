class GroupChatRoom < ApplicationRecord
  belongs_to :owner, class_name: "User", :foreign_key => "owner_id"
  has_many :messages, class_name: "ChatMessage", as: :room
  has_many :memberships, class_name: "GroupChatMembership"
  has_many :users, through: :memberships, source: :user
  scope :list_associated_with_current_user, -> (user_id) do
    # current_user = User.find_by_id(user_id)
    # select('id, owner_id, room_type, title, max_member_count, current_member_count')

  end
  scope :list_filtered_by_type, -> (room_type) {
    owner_keys = [:id, :name, :image_url]
    where(room_type: room_type).map { |chatroom|
      {
        id: chatroom.id,
        title: chatroom.title,
        protected: chatroom.password.nil?,
        owner: chatroom.owner.slice(*owner_keys),
        max_member_count: chatroom.max_member_count,
        current_member_count: chatroom.current_member_count,
        current_user_position: nil
      }
    }
  }
  # scope: :list_all, -> (room_type) {
  #   all.map { |chatroom|
  #     {
  #       id: chatroom.id,
  #       title: chatroom.title,
  #       protected: chatroom.password.nil?,
  #       owner: chatroom.owner.slice(*owner_keys),
  #       max_member_count: chatroom.max_member_count,
  #       current_member_count: chatroom.current_member_count,
  #       current_user_position: nil
  #     }
  #   }
  # }

  # def current_user_position
  #   "normal member"
  # end

end
