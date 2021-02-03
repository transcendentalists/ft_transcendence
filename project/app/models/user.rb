# Mainly performs login and logout related tasks.
class User < ApplicationRecord
  has_many :messages, class_name: 'ChatMessage'
  has_many :direct_chat_memberships
  has_many :direct_chat_rooms, through: :direct_chat_memberships, source: :room
  has_many :chat_bans
  has_many :group_chat_memberships
  has_many :in_group_chat_rooms, through: :group_chat_memberships, source: :room
  has_many :own_group_chat_rooms, foreign_key: 'owner_id', class_name: 'GroupChatRoom'
  has_one  :guild_membership
  has_one  :own_guild, foreign_key: 'owner_id', class_name: 'Guild'
  has_one  :in_guild, through: :guild_membership, source: :guild
  has_many :friendships
  has_many :scorecards
  has_many :matches, through: :scorecards
  has_many :tournament_memberships
  has_many :tournaments, through: :tournament_memberships

  def login(verification: false)
    return self if two_factor_auth && !verification

    update(status: 'online')
    self
  end

  def logout
    update(status: 'offline')
  end

  def to_simple
    permitted = %w[id name status two_factor_auth]
    data = attributes.filter { |field, _value| permitted.include?(field) }
  end

  def notice_login
    p 'Connected!'
    p 'Connected!'
    p 'Connected!'
    p 'Connected!'
    ActionCable.server.broadcast('appearance_channel', {
                                   id: id,
                                   name: name,
                                   status: status
                                 })
  end
end
