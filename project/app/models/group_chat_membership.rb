class GroupChatMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group_chat_room
end
