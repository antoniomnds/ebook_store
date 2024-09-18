10.times do |i|
  User.create! do |user|
    user.username = Faker::Internet.username
    user.email = Faker::Internet.email
    user.enabled = true
  end
end
  
