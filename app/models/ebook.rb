class Ebook < ApplicationRecord
  belongs_to :user
  has_many :purchases
  has_many :ebook_tags, dependent: :destroy
  has_many :tags, through: :ebook_tags

  enum :status, %i[archived draft pending live], prefix: true

  %i[preview_file cover_image].each do |attr|
    if Rails.configuration.active_storage.service == :cloudinary
      has_one_attached attr
    else
      # ActiveStorage attachment using local storage
      has_one_attached attr do |attachable|
        attachable.variant :thumb, resize_to_limit: [ 300, 300 ], preprocessed: true # process and cache the variant
      end
    end
  end

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

  scope :live, -> { where(status: :live) }

  def discount_value(discount)
    (price * (discount / 100.0)).round(2)
  end
end
