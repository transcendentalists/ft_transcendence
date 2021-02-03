class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :room, polymorphic: true
end
