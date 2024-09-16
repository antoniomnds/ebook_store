class Seller < ApplicationRecord
  belongs_to :user

  has_many :ebook_sellers

  has_many :ebooks,
    through: :ebook_sellers
end
