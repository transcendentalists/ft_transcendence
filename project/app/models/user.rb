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

  def login(verification: false)
    return self if self.two_factor_auth and not verification
    self.update(status: "online")
    self
  end

  def logout
    self.update(status: "offline")
  end

  def game_stat
    data = self.scorecards.group(:result).count
    stat = {}
    stat[:win_count], stat[:lose_count] = data[:win] ? data[:win] : 0, data[:lose] ? data[:lose] : 0
    stat[:tier] = [ "cooper", "bronze", "silver", "gold", "diamond" ][self.point / 100]
    stat[:rank] = User.order(point: :desc).index(self) + 1
    p stat
    return stat
  end

  def achievement
    data = self.tournament_memberships.group(:result).count
    { gold: data[:gold].to_i, silver: data[:silver].to_i, bronze: data[:bronze].to_i }
  end

  def profile
    permitted = ["id", "name", "title", "image_url"]
    stat = self.attributes.filter { |field, value| permitted.include?(field) }
    stat.merge!(self.game_stat)
    if not self.in_guild.nil?
      stat[:guild] = self.in_guild.to_simple
      stat[:guild][:position] = self.guild_membership.position
    end
    stat[:achievement] = self.achievement
    stat
  end

  def to_simple
    permitted = ["id", "name", "status", "two_factor_auth"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end
end
