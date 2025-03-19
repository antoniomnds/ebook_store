FactoryBot.define do
  factory :purchase do
    ebook
    buyer
    seller { association :seller, user: ebook.owner }
    price { Faker::Number.positive }
  end
end
