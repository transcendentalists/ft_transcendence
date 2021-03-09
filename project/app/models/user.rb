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
  scope :for_ladder_index, -> (page) { order(point: :desc).page(page.to_i).map { |user| user.profile } }
  validates :name, :email, uniqueness: true

  def login(verification: false)
    return self if two_factor_auth && !verification

    update_status('online')
    self
  end

  def logout
    update_status('offline')
  end

  def web_owner?
    self.position == "web_owner"
  end

  def banned?
    self.position == "ghost"
  end

  def can_service_manage?
    position_grade[self.position] >= 4
  end

  def can_be_service_banned_by?(user)
    return false unless user.can_service_manage?
    position_compare(user, self) > 0
  end

  def service_ban!
    self.update_status("offline")
    self.update!(position: "ghost")
    ActionCable.server.broadcast("notification_channel_#{self.id.to_s}", {type: "service_ban"})
  end

  def self.onlineUsersWithoutFriends(params)
    users = where_by_query(params)
    users = users.where.not(id: (Friendship.where(user_id: params[:user_id]).select(:friend_id)))
    users = select_by_query(users, params) unless params[:for].nil?
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
    return false if self.status != "playing"
    !self.matches.where.not(match_type: "tournament").find_by_status("pending").nil?
  end

  def waiting_match
    self.matches.where.not(match_type: "tournament").find_by_status("pending")
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
    permitted = ["id", "name", "title", "image_url", "position"]
    stat = self.attributes.filter { |field, value| permitted.include?(field) }
    stat.merge!(self.game_stat)
    stat[:achievement] = self.achievement

    if self.in_guild.nil?
      stat[:guild] = nil
      return stat
    end

    stat[:guild] = self.in_guild.to_simple
    stat[:guild][:membership_id] = self.guild_membership.id
    stat[:guild][:position] = self.guild_membership.position
    stat
  end

  def to_simple
    permitted = %w[id name status two_factor_auth image_url]
    data = attributes.filter { |field, value| permitted.include?(field) }
  end

  def friends_list(params)
    self.class.select_by_query(self.friends, params)
  end

  def update_status(status)
    self.update(status: status)
    ActionCable.server.broadcast('appearance_channel', make_user_data(status))
  end


  def for_chat_room_format
    hash_key_format = [:id, :name, :status, :image_url]
    self.slice(*hash_key_format).merge({
      anagram: guild_membership&.guild&.anagram
    })
  end

  def make_user_data(status)
    user_data = {
      id: id,
      name: name,
      status: status,
      image_url: image_url,
      anagram: guild_membership&.guild&.anagram
    }
  end

  def ready_for_match(match)
    card = match.scorecard_of(self)
    return false if card.nil?
    card.ready and true
  end

  def update_position!(options = { by: self, position: self.position })
    by_user = options[:by]
    position = options[:position]
    raise UserError.new("변경 권한이 없습니다.", 403) unless by_user.web_owner?
    raise UserError.new("현재 포지션과 변경하려는 포지션이 같습니다.", 400) if self.position == position
    self.update!(position: position)
  end

  def already_received_guild_invitation_by?(user)
    !self.guild_invitations.find_by_user_id(user.id).nil?
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
