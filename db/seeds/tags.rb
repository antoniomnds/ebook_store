retries = 1
begin
  10.times do |_|
      Tag.create! do |tag|
        tag.name = Faker::Book.genre # name is unique
        tag.description = Faker::Lorem.sentence
      end

    end
rescue ActiveRecord::RecordInvalid
  retries -= 1
  retry if retries >= 0
end
