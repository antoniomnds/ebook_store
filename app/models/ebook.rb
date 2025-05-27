class Ebook < ApplicationRecord
  include Filterable
  include Taggable

  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :purchases

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

  validates :genre,
            presence: true

  validates :authors,
            presence: true

  validates :publisher,
            presence: true

  validates :publication_date,
            presence: true

  validates :pages,
            presence: true

  validates :isbn,
            presence: true,
            format: {
              with: /\A978-\d{10}\z/,
              message: "has not a valid format"
            },
            uniqueness: true

  validate :publication_date_cannot_be_in_the_future

  scope :live, -> { where(status: :live) }
  scope :filter_by_tags, ->(tag_ids) { joins(:taggings)
                                         .where(taggings: { tag_id: tag_ids })
                                         .includes(:tags)
                                         .distinct }
  scope :filter_by_users, ->(user_ids) { where(user_id: user_ids) }

  def discount_value(discount)
    (price * (discount.to_i.clamp(0, 100) / 100.0)).round(2) # .to_i converts nil to 0
  end

  def publication_date_cannot_be_in_the_future
    if publication_date.present? && publication_date > Date.today
      errors.add(:publication_date, "can't be in the future")
    end
  end
end
