FactoryBot.define do
    factory :group_chat_room do
      owner_id { 42 }
      room_type { "public" }
      title { Faker::Game.title[1..20] }
      max_member_count { 10 }
      channel_code { Faker::Games::Pokemon.unique.name[1..20] }
      password { nil }
    end
  end