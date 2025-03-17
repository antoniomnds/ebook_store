require 'rails_helper'

RSpec.describe Purchase, type: :model do
  subject(:purchase) do
    user = build(:user)
    buyer = build(:buyer, user:)
    seller = build(:seller, user:)
    ebook = build(:ebook, owner: user)

    described_class.new(buyer: buyer, seller: seller, ebook: ebook, price: ebook.price)
  end

  describe "#set_purchased_at" do
    it "sets the purchased_at attribute to now", :aggregate_failures do
      expect(purchase.purchased_at).to be_nil
      purchase.send(:set_purchased_at)
      expect(purchase.purchased_at).to be_within(1.second).of(Time.current) # account for slight time difference
    end
  end

  context "when created" do
    it "sets the purchase date" do
      expect(purchase).to receive(:set_purchased_at).with(no_args)

      purchase.run_callbacks(:create)
    end
  end
end
