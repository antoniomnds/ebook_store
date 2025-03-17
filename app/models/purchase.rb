class Purchase < ApplicationRecord
  belongs_to :buyer
  belongs_to :seller
  belongs_to :ebook

  before_create :set_purchased_at


  private

  def set_purchased_at
    self.purchased_at = Time.now
  end
end
