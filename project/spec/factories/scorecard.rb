FactoryBot.define do
    factory :scorecard do
      user_id { 1 }
      match_id { 1 }
      side { "left" }
      score { 0 }
      result { "wait" }
    end
  end
