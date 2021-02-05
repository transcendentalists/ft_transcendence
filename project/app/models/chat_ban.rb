class ChatBan < ApplicationRecord
  belongs_to :user
  belongs_to :banned_user, class_name: "User", :foreign_key => "banned_user_id"

  def self.newChatBan(chatBanParams)
    unless exists?(user_id: chatBanParams[:user_id], banned_user_id: chatBanParams[:banned_user][:id])
      create(user_id: chatBanParams[:user_id], banned_user_id: chatBanParams[:banned_user][:id])
    end
  end

end
