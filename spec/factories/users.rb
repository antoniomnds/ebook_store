FactoryBot.define do
  factory :user, aliases: [ :owner ]  do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :with_live_ebooks do
      after(:create) do |user|
        create_pair(:ebook, :live, owner: user)
      end
    end
  end
end
