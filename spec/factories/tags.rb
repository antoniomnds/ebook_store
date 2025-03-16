FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "#{Faker::Lorem.word}_#{n}" }
    description { Faker::Lorem.sentence }
  end
end
