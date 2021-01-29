class User < ApplicationRecord
  has_many :messages, class_name: "ChatMessage"
  has_many :direct_chat_memberships
  has_many :direct_chat_rooms, through: :direct_chat_memberships, source: :room
  has_many :chat_bans
  has_many :group_chat_memberships
  has_many :in_group_chat_rooms, through: :group_chat_memberships, source: :room
  has_many :own_group_chat_rooms, foreign_key: "owner_id", class_name: "GroupChatRoom"
  has_one  :guild_membership
  has_one  :own_guild, foreign_key: "owner_id", class_name: "Guild"
  has_one  :in_guild, through: :guild_membership, source: :guild
  has_many :friendships
  has_many :scorecards
  has_many :matches, through: :scorecards
  has_many :tournament_memberships
  has_many :tournaments, through: :tournament_memberships
end
