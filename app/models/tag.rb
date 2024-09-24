class Tag < ApplicationRecord
  has_many :ebook_tags
  has_many :ebooks, through: :ebook_tags

  validates :name,
            presence: true,
            uniqueness: true
end
