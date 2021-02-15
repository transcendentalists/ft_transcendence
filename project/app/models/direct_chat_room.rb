class DirectChatRoom < ApplicationRecord
  has_many :messages, class_name: "ChatMessage", as: :room
  has_many :memberships, class_name: "DirectChatMembership"
  has_many :users, through: :memberships, source: :user
  validates :symbol, uniqueness: true
end
