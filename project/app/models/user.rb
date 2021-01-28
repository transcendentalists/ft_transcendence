class User < ApplicationRecord
  has_many :messages, class_name: "ChatMessage" # H
  
  has_many :direct_chat_bans
  has_many :friendships
  has_many :direct_chat_memberships
  has_many :group_chat_memberships
  has_many :group_chat_rooms, foreign_key: "owner_id", class_name: "GroupChatRoom"
  has_one :guild_membership
  has_one :guild, foreign_key: "owner_id", class_name: "Guild"
  has_many :scorecards
  has_many :tournament_memberships
end
