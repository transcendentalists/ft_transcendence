FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    password { "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO" }
    email { Faker::Internet.unique.email }
    point { Faker::Number.number(digits: 3) }
  end
end
