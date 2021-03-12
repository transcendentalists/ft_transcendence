FactoryBot.define do
  # eventable_type: War, Tournament
  # match_type: war, dual, ladder, casual_ladder, tournament
  # start_time: 경기 시작하는 시간
  factory :match do
    rule_id { 1 }
    eventable_type { "War" }
    eventable_id { 1 }
    match_type { "dual" }
    status { "pending" }
    start_time { Time.zone.now }
    target_score { [3,5,7,10][Faker::Number.within(range: 0..3)]}
  end
end
