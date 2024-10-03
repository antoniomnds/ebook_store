FactoryBot.define do
  factory :ebook do
    title { "Example Ebook" }
    status { :live }
    price { 9.99 }
    authors { "John Doe" }
    genre { "Fiction" }
    publisher { "Acme Publishing" }
    publication_date { "2024-09-23" }
    pages { 100 }
    isbn { "978-3589352332" }
    user
  end
end
