require 'bcrypt'

class GroupChatRoom < ApplicationRecord
  belongs_to :owner, class_name: "User", :foreign_key => "owner_id"
  has_many :messages, class_name: "ChatMessage", as: :room, dependent: :destroy
  has_many :memberships, class_name: "GroupChatMembership", dependent: :destroy
  has_many :users, through: :memberships, source: :user
  validates :title, presence: true, length: {minimum: 1, maximum: 20}, allow_blank: false
  validates :max_member_count, :inclusion => { :in => 2..10 }
  validates :room_type, inclusion: { in: ["public", "private"] }
  scope :list_associated_with_current_user, -> (current_user) do
    current_user.in_group_chat_rooms.includes(:owner).map { |chat_room| 
      {
        id: chat_room.id,
        title: chat_room.title,
        locked: chat_room.locked?,
        owner: chat_room.owner.for_chat_room_format,
        max_member_count: chat_room.max_member_count,
        current_member_count: chat_room.active_member_count,
        current_user: {
          position: chat_room.memberships.find_by_user_id(current_user.id)&.position
        }
      }
    }
  end
  scope :list_filtered_by_type, -> (room_type, current_user) {
    current_user_room_ids = current_user.group_chat_memberships.where.not(position: "ghost").pluck(:group_chat_room_id)

    where(room_type: room_type).where.not(id: current_user_room_ids).map { |chat_room|
      {
        id: chat_room.id,
        title: chat_room.title,
        locked: chat_room.locked?,
        owner: chat_room.owner.for_chat_room_format,
        max_member_count: chat_room.max_member_count,
        current_member_count: chat_room.active_member_count,
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

  def for_admin_format
    {
      id: self.id,
      title: self.title,
      messages: self.messages.map { |message|
        {
          name: message.user.name,
          message: message.message,
          created_at: message.created_at.strftime("%F %T")
        }
      }
    }
  end

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

  def locked?
    !self.password.blank?
  end

  def valid_password?(input_password)
    BCrypt::Password::new(self.password) == input_password
  end

  def active_member_count
    self.memberships.where.not(position: "ghost").count
  end

  def for_chat_room_format
    hash_key_format = [ :id, :room_type, :title, :max_member_count, 
                          :current_member_count, :channel_code ]
    self.slice(*hash_key_format)
  end

  def membership_by_user(user)
    membership = self.memberships.find_by_user_id(user.id)

    { membership_id: membership.id,
      position: membership.position,
      mute:     membership.mute      }
  end

  def members
    members = []
    self.memberships.each do |membership|
      member_hash = User.find_by_id(membership.user_id).for_chat_room_format.merge({
        membership_id: membership.id,
        position: membership.position,
        mute: membership.mute
      })
      members.push(member_hash)
    end
    members
  end

  # TODO: web_admin도 할 수 있도록 추후 수정할 것.
  def can_be_update_by?(current_user)
    self.owner_id == current_user.id
  end

  def update_by_params(params)
    if params[:password].blank?
      self.password = nil
    else
      self.password = BCrypt::Password::create(params[:password]) 
    end
    save!
  end

  def join(user, position = "member")
    return nil if user.nil?
    return nil if self.active_member_count == self.max_member_count
    membership = GroupChatMembership.create(user_id: user.id, group_chat_room_id: self.id, position: position)
    ActionCable.server.broadcast(
      "group_chat_channel_#{self.id.to_s}",
      {
        type: "join",
        user_id: user.id,
        user: user.for_chat_room_format.merge({
          membership_id: membership.id,
          position: membership.position,
          mute: membership.mute
        })
      }
    )
    membership
  end

  def make_another_member_owner
    memberships = self.memberships

    new_owner = memberships.find_by_position("admin")
    new_owner = memberships.find_by_position("member") if new_owner.nil?
    self.update!(owner_id: new_owner.user_id)
    new_owner.update_position("owner")
    new_owner.update_mute(false) if new_owner.mute?
  end

end
