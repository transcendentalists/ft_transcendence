class DirectChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :direct_chat_room
end
