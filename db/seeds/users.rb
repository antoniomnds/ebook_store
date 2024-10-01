10.times do |i|
  User.create! do |user|
    user.username = Faker::Internet.username
    user.password = Faker::Internet.password
    user.email = Faker::Internet.email
    user.enabled = true
  end
end
