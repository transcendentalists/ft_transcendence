class DirectChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :room, class_name: "DirectChatRoom", foreign_key: "direct_chat_room_id"
end
