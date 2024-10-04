require 'rails_helper'
require 'support/shared_contexts/logging'
require 'support/shared_examples/model'

RSpec.describe Purchase, type: :model do
  subject(:purchase) do
    user = build(:user)
    buyer = build(:buyer, user:)
    seller = build(:seller, user:)
    ebook = build(:ebook, user:)

    described_class.new(buyer: buyer, seller: seller, ebook: ebook, price: ebook.price)
  end

  let(:ebook) { build(:ebook) }

  include_context "logging"

  include_examples "model"

  describe "#before_create" do
    it "has a purchase date" do
      purchase.save!
      expect(purchase.purchased_at).to_not be_nil
    end
  end
end
