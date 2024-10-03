FactoryBot.define do
  factory :user do
    username { "John Doe" }
    email { "john.doe@example.com" }
    password { "password" }
    enabled { true }
    active { true }
    admin { false }
  end

  factory :random_user, class: User do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    enabled { true }
    active { true }
    admin { false }
  end
end
