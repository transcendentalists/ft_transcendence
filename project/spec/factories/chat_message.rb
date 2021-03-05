FactoryBot.define do
    factory :chat_message do
      user_id { 1 }
      room_type { "GroupChatRoom" }
      room_id { 1 }
      message { Faker::Books::Lovecraft.sentences }
    end
  end