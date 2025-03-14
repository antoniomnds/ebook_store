FactoryBot.define do
  factory :user, aliases: [ :owner ]  do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
