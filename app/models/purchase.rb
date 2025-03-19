class Purchase < ApplicationRecord
  belongs_to :buyer
  belongs_to :seller
  belongs_to :ebook

  validates :price,
           presence: true,
           numericality: { greater_than_or_equal_to: 0.0 }

  validate :seller_is_ebook_owner, if: -> { seller and ebook }

  before_create :set_purchased_at


  private

  def set_purchased_at
    self.purchased_at = Time.zone.now
  end

  def seller_is_ebook_owner
    if seller.user != ebook.owner
      errors.add(:seller, "Seller must be the owner of the ebook being sold")
    end
  end
end
