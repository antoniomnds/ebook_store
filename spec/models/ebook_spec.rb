require 'rails_helper'
require 'support/shared_examples/model'
require 'support/shared_contexts/logging'

RSpec.describe Ebook, type: :model do
  subject(:ebook) { build(:ebook) }

  include_context "logging"

  include_examples "model"

  it "has zero sales by default" do
    expect(ebook.sales).to be_zero
  end

  it "has zero views by default" do
    expect(ebook.views).to be_zero
  end

  it "has zero preview downloads by default" do
    expect(ebook.preview_downloads).to be_zero
  end

  describe "#title" do
    it "is required" do
      ebook.title = nil
      ebook.valid?
      expect(ebook.errors[:title].first).to match(/blank/)
      expect(ebook.errors[:title].last).to match(/too short \(minimum is 4 characters\)/)
    end

    context "with a title less than four characters" do
      it "should be invalid" do
        ebook.title = "A" * 3
        ebook.valid?
        expect(ebook.errors[:title].first).to match(/too short \(minimum is 4 characters\)/)
      end
    end
  end

  describe "#status" do
    it "is required" do
      ebook.status = nil
      ebook.valid?
      expect(ebook.errors[:status].first).to match(/blank/)
    end

    it "belongs to a predefined set of values" do
      expect(ebook.status).to satisfy("be one of #{ Ebook.statuses.keys }") do |status|
        Ebook.statuses.keys.include?(status)
      end
    end
  end

  describe "#price" do
    it "is required" do
      ebook.price = nil
      ebook.valid?
      expect(ebook.errors[:price].first).to match(/blank/)
      expect(ebook.errors[:price].last).to match(/not a number/)
    end

    it "should not be negative" do
      ebook.price = -1
      ebook.valid?
      expect(ebook.errors[:price].first).to match(/greater than or equal to 0.0/)
    end
  end

  describe "#authors" do
    it "is required" do
      ebook.authors = nil
      ebook.valid?
      expect(ebook.errors[:authors].first).to match(/blank/)
    end
  end

  describe "#genre" do
    it "is required" do
      ebook.genre = nil
      ebook.valid?
      expect(ebook.errors[:genre].first).to match(/blank/)
    end
  end

  describe "#publisher" do
    it "is required" do
      ebook.publisher = nil
      ebook.valid?
      expect(ebook.errors[:publisher].first).to match(/blank/)
    end
  end

  describe "#publication date" do
    it "is required" do
      ebook.publication_date = nil
      ebook.valid?
      expect(ebook.errors[:publication_date].first).to match(/blank/)
    end

    it "should not be in the future" do
      ebook.publication_date = Date.tomorrow
      ebook.valid?
      expect(ebook.errors[:publication_date]).to contain_exactly "can't be in the future"
    end
  end

  describe "#pages" do
    it "is required" do
      ebook.pages = nil
      ebook.valid?
      expect(ebook.errors[:pages].first).to match(/blank/)
    end
  end

  describe "#ISBN" do
    it "is required" do
      ebook.isbn = nil
      ebook.valid?
      expect(ebook.errors[:isbn].first).to match(/blank/)
      expect(ebook.errors[:isbn].last).to match(/not a valid format/)
    end

    it "has a defined format" do
      expect(ebook.isbn).to match(/\A978-\d{10}\z/)
    end
  end

  describe "#user" do
    it "is required" do
      ebook.user = nil
      ebook.valid?
      expect(ebook.errors[:user].first).to match(/must exist/)
    end
  end

  describe "#discount_value" do
    context "with a valid discount value" do
      it "should return the correct discount value" do
        discount = 10
        net_price = (ebook.price * (discount.fdiv(100))).round(2)
        expect(ebook.discount_value(discount)).to eq(net_price)
      end
    end

    context "with a negative discount value" do
      it "should return zero" do
        expect(ebook.discount_value(-1)).to be_zero
      end
    end

    context "with a discount above 100" do
      it "should return the price" do
        expect(ebook.discount_value(110)).to eq(ebook.price)
      end
    end
  end
end
