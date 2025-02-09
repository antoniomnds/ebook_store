20.times do
  num_users = User.count
  num_tags = Tag.count
  Ebook.create! do |ebook|
    ebook.title = Faker::Book.title
    ebook.status = %w[draft pending live].sample
    ebook.price = Faker::Number.decimal(l_digits: 2)
    ebook.authors = Faker::Book.author
    ebook.publisher = Faker::Book.publisher
    ebook.genre = Faker::Book.genre
    ebook.pages = Faker::Number.number(digits: 3)
    ebook.publication_date = Faker::Date.between(from: 20.years.ago, to: Date.today)
    ebook.isbn = "978-#{Faker::Number.number(digits: 10)}"
    ebook.sales = Faker::Number.number(digits: 3)
    ebook.views = Faker::Number.number(digits: 5)
    ebook.preview_downloads = Faker::Number.number(digits: 4)
    ebook.owner = User.find(rand(1..num_users))
    ebook.tags << Tag.find(rand(1..num_tags))
  end
end
