FactoryBot.define do
  factory :tournament do
    rule_id { Faker::Number.within(range: 1..7) }
    title { Faker::Game.title }
    max_user_count { [8,16,32][Faker::Number.within(range: 0..2)]}
    incentive_title { Faker::Superhero.prefix }
    target_match_score { [3,5,7,10][Faker::Number.within(range: 0..3)]}
    start_date { Faker::Date.backward(days: 7) }
    tournament_time { Time.new.change(hour: Faker::Number.within(range: 1..23)) }
  end
end
