10.times do |i|
  User.create! do |user|
    user.username = "Test#{i}"
    user.email = "test#{i}@example.com"
    user.enabled = true
  end
end
