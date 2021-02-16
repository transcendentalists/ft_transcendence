require 'bcrypt'

class GroupChatRoom < ApplicationRecord
  belongs_to :owner, class_name: "User", :foreign_key => "owner_id"
  has_many :messages, class_name: "ChatMessage", as: :room
  has_many :memberships, class_name: "GroupChatMembership"
  has_many :users, through: :memberships, source: :user
  validates :title, presence: true, length: {minimum: 1, maximum: 20}, allow_blank: false
  validates :max_member_count, :inclusion => { :in => 2..10 }
  validates :room_type, inclusion: { in: ["public", "private"] }
  scope :list_associated_with_current_user, -> (current_user) do
    current_user.in_group_chat_rooms.includes(:owner).map { |chat_room| 
      {
          id: chat_room.id,
          title: chat_room.title,
          locked: chat_room.is_locked?,
          owner: chat_room.owner.for_chat_room_format,
          max_member_count: chat_room.max_member_count,
          current_member_count: chat_room.users.count,
          current_user: {
            position: chat_room.memberships.find_by_id(current_user.id)&.position
          }
      }
    }
  end
  scope :list_filtered_by_type, -> (room_type, current_user) {
    current_user_room_ids = current_user.in_group_chat_room_ids
    where(room_type: room_type).where.not(id: current_user_room_ids).map { |chat_room|
      {
        id: chat_room.id,
        title: chat_room.title,
        locked: chat_room.is_locked?,
        owner: chat_room.owner.for_chat_room_format,
        max_member_count: chat_room.max_member_count,
        current_member_count: chat_room.users.count,
        current_user: {
          position: nil
        }
      }
    }
  }
  scope :matching_channel_code, -> (channel_code, current_user) {
    chat_room = self.find_by_channel_code(channel_code)
    return nil if chat_room.nil?
    chat_room.for_chat_room_format.merge({
      current_user: {
        position: chat_room.memberships.find_by_id(current_user.id)&.position
      }
    })
  }

  
  def for_chat_room_format
    hash_key_format = [ :id, :room_type, :title, :max_member_count, 
                          :current_member_count, :channel_code ]
    self.slice(*hash_key_format)
  end

  def current_user_info(user)
    current_user_membership = self.memberships.find_by_user_id(user.id)

    {
      position: current_user_membership.position,
      mute: current_user_membership.mute
    }
  end

  def members
    members = []
    self.memberships.each do |member|
      member_hash = User.find_by_id(member.user_id).for_chat_room_format.merge({
        position: member.position,
        mute: member.mute
      })
      members.push(member_hash)
    end
    members
  end

  def is_locked?
    !self.password.blank?
  end

  def is_valid_password?(input_password)
    BCrypt::Password::new(self.password) == input_password
  end

  def update_by_params(params)
    update_keys = {}
    update_keys.merge!({title: params[:title]}) if params[:title]
    update_keys.merge!({room_type: params[:room_type]}) if params[:room_type]
    if params[:password]
      password = params[:password] == "" ? nil : BCrypt::Password::create(params[:password])
      update_keys.merge!({password: password})
    end

    self.update(update_keys) if update_keys
  end

  # def is_user_authorized_to_destroy(current_user)
  #   current_user_position = self.memberships.find_by_user_id(current_user.id)&.position
  #   authorized_position = ["web_admin"]
  #   authorized_position.include?(current_user_position)
  # end

  def self.generate(create_params)
    GroupChatRoom.transaction do
      room = GroupChatRoom.create(create_params)
      raise ActiveRecord::Rollback if !room.persisted? || !create_params.has_key?(:owner_id)
      user = User.find_by_id(create_params[:owner_id])
      membership = room.join(user, "owner")
      raise ActiveRecord::Rollback if membership.nil? || !membership.persisted?
      room
    end
  end

  def join(user, position = "member")
    return nil if user.nil?
    return nil if self.current_member_count == self.max_member_count
    GroupChatMembership.create(user_id: user.id, group_chat_room_id: self.id, position: position)
  end
end
