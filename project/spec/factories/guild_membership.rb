FactoryBot.define do
  factory :guild_membership do
    user_id { 1 }
    guild_id { 1 }
    position { "member" }
  end
end