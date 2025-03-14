FactoryBot.define do
  factory :ebook do
    title { Faker::Book.title }
    status { %w[draft pending live].sample }
    price { Faker::Number.decimal(l_digits: 2) }
    authors { Faker::Book.author }
    genre { Faker::Book.genre }
    publisher { Faker::Book.publisher }
    publication_date { Faker::Date.between(from: 40.years.ago, to: Date.today) }
    pages { Faker::Number.number(digits: 3) }
    isbn { "978-#{Faker::Number.number(digits: 10)}" }
    owner
  end
end
