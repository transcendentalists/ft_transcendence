FactoryBot.define do
    factory :guild do
      owner_id { 77 }
      name { "gonniiaa" }
      anagram { "@iaa" }
      image_url { "assets/default_guild.png" }
      point { 0 }
    end
  end