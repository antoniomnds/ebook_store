class Ebook < ApplicationRecord
  has_many :ebook_buyers

  has_many :buyers,
    through: :buyer_ebooks

  has_many :ebook_sellers

  has_many :sellers,
    through: :seller_ebooks

  enum :status, %i[draft pending live], prefix: true

  validates :title,
    presence: true,
    length: { minimum: 4 }

  validates :status,
    presence: true

  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 0.0 }

  validates :authors,
    presence: true

  validates :publisher,
    presence: true

  validates :publication_date,
    presence: true

  validates :pages,
      presence: true

  validates :isbn,
    presence: true
end
