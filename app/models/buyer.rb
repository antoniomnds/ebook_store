class Buyer < ApplicationRecord
  belongs_to :user

  has_many :ebook_buyers

  has_many :ebooks,
    through: :ebook_buyers
end
