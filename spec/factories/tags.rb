FactoryBot.define do
  factory :tag do
    name { Faker::Book.genre }
    description { Faker::Lorem.sentence }
  end
end
