FactoryBot.define do
    factory :group_chat_membership do
      user_id { 1 }
      group_chat_room_id { 1 }
      position { "member" }
      mute { false }
      ban_ends_at { nil }
    end
  end