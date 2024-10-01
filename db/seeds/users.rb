10.times do |i|
  User.create! do |user|
    user.username = Faker::Internet.username
    user.password = Faker::Internet.password
    user.email = Faker::Internet.email
    user.enabled = true
  end
end

# a known admin user
User.create! do |user|
  user.username = "admin"
  user.password = "password"
  user.email = "admin@example.com"
  user.enabled = true
  user.is_admin = true
end
