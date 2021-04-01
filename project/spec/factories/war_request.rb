FactoryBot.define do
  factory :war_request do
    rule_id { 1 }
    bet_point { 100 }
    start_date { Time.zone.now }
    end_date { Time.zone.now }
    war_time { Time.zone.now }
    max_no_reply_count { 1 }
    include_ladder { false }
    include_tournament { false }
    target_match_score { 1 }
  end
end
