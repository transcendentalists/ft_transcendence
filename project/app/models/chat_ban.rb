class ChatBan < ApplicationRecord
  belongs_to :user
  belongs_to :banned_user, class_name: 'User', foreign_key: 'banned_user_id'

  def self.newChatBan(chatBanParams)
    unless exists?(user_id: chatBanParams[:user_id], banned_user_id: chatBanParams[:banned_user][:id])
      create(user_id: chatBanParams[:user_id], banned_user_id: chatBanParams[:banned_user][:id])
    end
  end

  def self.destroyChatBan(chatBanParams)
    if exists?(user_id: chatBanParams[:user_id], banned_user_id: chatBanParams[:id])
      chat_ban = where(user_id: chatBanParams[:user_id]).find_by_banned_user_id(chatBanParams[:id])
      chat_ban.destroy
    end
  end
end
