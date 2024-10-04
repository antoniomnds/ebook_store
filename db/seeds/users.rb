10.times do |i|
  User.create! do |user|
    user.username = Faker::Internet.username
    user.password = Faker::Internet.password
    user.email = Faker::Internet.email
  end
end

# a known admin user
User.find_or_create_by!(email: "admin@example.com") do |user|
  user.username = "admin"
  user.password = "password"
  user.admin = true
end
