require 'rails_helper'

RSpec.describe Purchase, type: :model do
  subject(:purchase) do
    user = build(:user)
    buyer = build(:buyer, user:)
    seller = build(:seller, user:)
    ebook = build(:ebook, user:)

    described_class.new(buyer: buyer, seller: seller, ebook: ebook, price: ebook.price)
  end

  describe "#before_create" do
    it "has a purchase date" do
      purchase.save!
      expect(purchase.purchased_at).to_not be_nil
    end
  end
end
