20.times do |_|
  begin
    Tag.create! do |tag|
      tag.name = Faker::Book.genre
      tag.description = Faker::Lorem.sentence
    end
  rescue ActiveRecord::RecordInvalid
    retry
  end
end
