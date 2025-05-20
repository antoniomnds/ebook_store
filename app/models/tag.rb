class Tag < ApplicationRecord
  has_many :ebook_tags
  has_many :ebooks, through: :ebook_tags

  validates :name,
            presence: true,
            uniqueness: true

  scope :with_live_ebooks, -> { joins(:ebooks).distinct.merge(Ebook.live) }
  scope :with_ebooks_for_user, ->(user) { joins(:ebooks).distinct.where(ebooks: { owner: user }) }
end
