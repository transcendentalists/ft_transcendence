FactoryBot.define do
  factory :war_status do
    guild_id { 1 }
    war_request_id { 1 }
    position { "enemy" }
    no_reply_count { 0 }
    point { 0 }
  end
end
