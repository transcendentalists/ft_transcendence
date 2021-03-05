FactoryBot.define do
    factory :group_chat_room do
      owner_id { 42 }
      room_type { "public" }
      title { Faker }
      image_url { "assets/default_guild.png" }
      point { 0 }
    end
  end