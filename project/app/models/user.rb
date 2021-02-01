# Mainly performs login and logout related tasks.
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

  def self.session_login(login_params)
    user = find_by_name(login_params[:name]);
    user.login if not user.two_factor_auth
    return user
  end

  def self.session_logout(id)
    if (User.exists?(id))
      user = User.find(id)
      user.logout
    end
  end

  def login
    self.update(status: "online")
  end

  def logout
    self.update(status: "offline")
  end

  def to_backbone_simple
    permitted = ["id", "name", "status", "two_factor_auth"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end
end
