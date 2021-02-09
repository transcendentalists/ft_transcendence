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

  scope :for_ladder_index, -> (page) { order(point: :desc).page(page.to_i).map { |user| user.profile } }
  
  def login(verification: false)
    return self if two_factor_auth && !verification

    update(status: 'online')
    self
  end

  def logout
    update(status: 'offline')
  end

  def self.where_by_query(params)
    users = all # User == self
    params.each do |k, v|
      next if k == 'for'

      users = users.where(k => v)
    end
    users
  end

  def self.select_by_query(users, params)
    if params[:for] == 'appearance'
      users.left_outer_joins(guild_membership: :guild).select('users.id, users.name, users.status, users.image_url, guilds.anagram')
    else
      users
    end
  end

  def playing?
    self.status == "playing"
  end

  def ladder_waiting?
    self.status == "playing"
  end

  # instance methods for game
  def playing_match
    self.matches&.find_by_status(:progress)
  end

  def waiting_match?
    self.matches&.exists?(status: "pending")
  end

  def waiting_match
    self.matches&.find_by_status(:pending)
  end

  def enemy
    self.playing_match&.users&.where&.not(id: self.id)
  end

  def tier
    [ "cooper", "bronze", "silver", "gold", "diamond" ][self.point / 100]
  end

  def game_stat
    data = self.scorecards.group(:result).count
    stat = {}
    stat[:win_count], stat[:lose_count] = data['win'] ? data['win'] : 0, data['lose'] ? data['lose'] : 0
    stat[:tier] = self.tier
    stat[:rank] = User.order(point: :desc).index(self) + 1
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
    stat[:achievement] = self.achievement
    
    if self.in_guild.nil?
      stat[:guild] = nil
      return stat
    end
    
    stat[:guild] = self.in_guild.to_simple
    stat[:guild][:position] = self.guild_membership.position
    stat
  end

  def to_simple
    permitted = %w[id name status two_factor_auth]
    data = attributes.filter { |field, _value| permitted.include?(field) }
  end

  def notice_login
    user_data = {
      id: id,
      name: name,
      status: status,
      image_url: image_url,
      anagram: guild_membership.nil? ? nil : guild_membership.guild.anagram
    }
    ActionCable.server.broadcast('appearance_channel', user_data)
  end

  def notice_logout
    # cookies.encrypted[:service_id]
    ActionCable.server.broadcast('appearance_channel', {
                                   id: id,
                                   name: name,
                                   status: status
                                 })
  end
end
