require 'rails_helper'

RSpec.describe Purchase, type: :model do
  subject(:purchase) { build(:purchase) }

  describe "Validation tests" do
    describe "#buyer" do
      it "is required" do
        purchase.buyer = nil
        purchase.valid?
        expect(purchase.errors[:buyer].first).to match(/must exist/)
      end
    end

    describe "#seller" do
      it "is required" do
        purchase.seller = nil
        purchase.valid?
        expect(purchase.errors[:seller].first).to match(/must exist/)
      end

      it "is the ebook owner" do
        purchase.seller.user = build(:user) # other than the ebook owner
        purchase.valid?
        expect(purchase.errors[:seller].first).to match(/must be the owner of the ebook/)
      end
    end

    describe "#ebook" do
      it "is required" do
        purchase.ebook = nil
        purchase.valid?
        expect(purchase.errors[:ebook].first).to match(/must exist/)
      end
    end

    describe "#price" do
      it "is required" do
        purchase.price = nil
        purchase.valid?
        expect(purchase.errors[:price].first).to match(/blank/)
      end

      it "is greater than or equal to zero" do
        purchase.price = -1.to_d
        purchase.valid?
        expect(purchase.errors[:price].first).to match(/greater than or equal to 0.0/)
      end
    end
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
