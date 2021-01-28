class DirectChatRoom < ApplicationRecord
  has_many :messages, class_name: "ChatMessage", as: :room # H
  has_many :direct_chat_memberships
end
