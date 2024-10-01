class Purchase < ApplicationRecord
  belongs_to :buyer
  belongs_to :seller
  belongs_to :ebook

  before_create :set_purchase_at


  private

  def set_purchase_at
    self.purchased_at = Time.now
  end
end
