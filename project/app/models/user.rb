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
  has_many :guild_invitations, foreign_key: "invited_user_id"
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend
  has_many :scorecards
  has_many :matches, through: :scorecards
  has_many :tournament_memberships
  has_many :tournaments, through: :tournament_memberships
  has_one_attached :avatar
  
  validates :name, uniqueness: true, length: {minimum: 1}
  validates :email, uniqueness: true, length: {minimum: 1}

  scope :for_ladder_index, -> (page) { order(point: :desc).page(page.to_i).map { |user| user.profile } }  

  def self.onlineUsersWithoutFriends(params)
    users = where_by_query(params)
    users = users.where.not(id: (Friendship.where(user_id: params[:user_id]).select(:friend_id)))
    users = select_by_query(users, params) unless params[:for].nil?
  end

  def self.in_same_war?
    return false unless self.count == 2
    return false if !self.first.in_guild&.in_war? || !self.second.in_guild&.in_war?
    self.first.in_guild.current_war == self.second.in_guild.current_war
  end

  def friends_list(params)
    self.class.select_by_query(self.friends, params)
  end

  def profile
    permitted = ["id", "name", "title", "image_url", "position", "point"]
    stat = self.attributes.filter { |field, value| permitted.include?(field) }
    stat.merge!(self.game_stat)
    stat[:achievement] = self.achievement
    stat[:guild] = self.in_guild&.to_simple
    stat
  end

  def to_simple
    permitted = %w[id name status two_factor_auth image_url]
    data = attributes.filter { |field, value| permitted.include?(field) }
  end

  def can_service_manage?
    position_grade[self.position] >= position_grade["web_admin"]
  end

  def can_be_service_banned_by?(user)
    return false unless user.can_service_manage?
    position_compare(user, self) > 0
  end

  def verification!(verification_code)
    raise ServiceError.new unless self.verification_code == verification_code
  end

  def valid_password?(password)
    return BCrypt::Password.new(self.password) == password
  end

  def login(verification: false)
    return self if self.two_factor_auth? && !verification
    update_status('online')
  end

  def logout
    update_status('offline')
  end

  def for_appearance(status)
    user_data = {
      id: id,
      name: name,
      status: status,
      image_url: image_url,
      anagram: guild_membership&.guild&.anagram
    }
  end

  def for_chat_room_format
    hash_key_format = [:id, :name, :status, :image_url]
    self.slice(*hash_key_format).merge({
      anagram: guild_membership&.guild&.anagram
    })
  end

  def ready_for_match(match)
    card = match.scorecard_of(self)
    return false if card.nil?
    card.ready
    true
  end

  def update_position!(options = { by: self, position: self.position })
    by_user = options[:by]
    position = options[:position]
    raise ServiceError.new(:Forbidden) unless by_user.web_owner?
    raise ServiceError.new(:BadRequest, "현재 포지션과 변경하려는 포지션이 같습니다.") if self.position == position
    self.update!(position: position)
  end

  def update_status(status)
    self.update(status: status)
    ActionCable.server.broadcast('appearance_channel', self.for_appearance(status))
    self
  end

  def service_ban!
    self.update_status("offline")
    self.update!(position: "ghost")
    self.notification("service_ban")
  end

  def notification(type)
    ActionCable.server.broadcast("notification_channel_#{self.id.to_s}", {type: type})
  end

  def playing_match
    self.matches&.find_by_status(:progress)
  end

  def waiting_match?
    return false if self.status != "playing"
    !self.matches.where.not(match_type: "tournament").find_by_status("pending").nil?
  end

  def waiting_match
    self.matches.where.not(match_type: "tournament").find_by_status("pending")
  end

  def enemy
    self.playing_match&.users&.where&.not(id: self.id)
  end

  def offline?
    self.status == "offline"
  end

  def playing?
    self.status == "playing"
  end

  def web_owner?
    self.position == "web_owner"
  end

  def banned?
    self.position == "ghost"
  end

  def in_guild?
    !self.in_guild.nil?
  end

  def already_received_guild_invitation_by?(user)
    !self.guild_invitations.find_by_user_id(user.id).nil?
  end

  def tier
    return "diamond" if self.point >= 400
    [ "cooper", "bronze", "silver", "gold" ][self.point / 100]
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

  private

  def self.where_by_query(params)
    users = self.all
    params.except(:for, :user_id).each do |k, v|
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
end
