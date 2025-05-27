class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :ebooks, through: :taggings, source: :taggable, source_type: "Ebook"

  validates :name,
            presence: true,
            uniqueness: true
end
