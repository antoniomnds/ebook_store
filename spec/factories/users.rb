FactoryBot.define do
  factory :user, aliases: [ :owner ]  do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :with_ebooks do
      after(:create) do |user|
        create_pair(:ebook, owner: user)
      end
    end
  end
end
