class ChatBan < ApplicationRecord
  belongs_to :user
  belongs_to :banned_user, class_name: 'User', foreign_key: 'banned_user_id'
end
