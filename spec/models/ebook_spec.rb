require 'rails_helper'
require 'support/shared_examples/model'
require 'support/shared_contexts/logging'

RSpec.describe Ebook, type: :model do
  subject(:ebook) do
    user = User.create(username: "test", email: "test@example.com")

    described_class.new(
      title: "Example Ebook",
      status: :live,
      price: 9.99,
      authors: "John Doe",
      genre: "Fiction",
      publisher: "Acme Publishing",
      publication_date: "2024-09-23",
      pages: 100,
      isbn: "978-3589352332",
      user: user
    )
  end

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

  it { is_expected.to have_attributes(
                        title: "Example Ebook",
                        status: "live",
                        price: 9.99,
                        authors: "John Doe",
                        genre: "Fiction",
                        publisher: "Acme Publishing",
                        publication_date: DateTime.parse("2024-09-23"),
                        pages: 100,
                        isbn: "978-3589352332",
                        sales: 0,
                        views: 0,
                        preview_downloads: 0,
                        user: be_a(User)
                      )}

  describe "#title" do
    it "is required" do
      ebook.title = nil
      ebook.valid?
      expect(ebook.errors[:title].size).to eq(2) # blank and too short
    end

    context "with a title less than four characters" do
      it "should be invalid" do
        ebook.title = "A" * 3
        ebook.valid?
        expect(ebook.errors[:title].size).to eq(1)
      end
    end
  end

  describe "#status" do
    it "is required" do
      ebook.status = nil
      ebook.valid?
      expect(ebook.errors[:status].size).to eq(1)
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
      expect(ebook.errors[:price].size).to eq(2) # blank and not a number
    end

    it "should not be negative" do
      ebook.price = -1
      ebook.valid?
      expect(ebook.errors[:price].size).to eq(1)
    end
  end

  describe "#authors" do
    it "is required" do
      ebook.authors = nil
      ebook.valid?
      expect(ebook.errors[:authors].size).to eq(1)
    end
  end

  describe "#genre" do
    it "is required" do
      ebook.genre = nil
      ebook.valid?
      expect(ebook.errors[:genre].size).to eq(1)
    end
  end

  describe "#publisher" do
    it "is required" do
      ebook.publisher = nil
      ebook.valid?
      expect(ebook.errors[:publisher].size).to eq(1)
    end
  end

  describe "#publication date" do
    it "is required" do
      ebook.publication_date = nil
      ebook.valid?
      expect(ebook.errors[:publication_date].size).to eq(1)
    end

    it "should not be in the future" do
      ebook.publication_date = Date.tomorrow
      ebook.valid?
      expect(ebook.errors[:publication_date].size).to eq(1)
    end
  end

  describe "#pages" do
    it "is required" do
      ebook.pages = nil
      ebook.valid?
      expect(ebook.errors[:pages].size).to eq(1)
    end
  end

  describe "#ISBN" do
    it "is required" do
      ebook.isbn = nil
      ebook.valid?
      expect(ebook.errors[:isbn].size).to eq(1)
    end

    it "has a defined format" do
      expect(ebook.isbn).to satisfy do |isbn|
        isbn.match(/^978-\d{10}$/)
      end
    end
  end

  describe "#user" do
    it "is required" do
      ebook.user = nil
      ebook.valid?
      expect(ebook.errors[:user].size).to eq(1)
    end
  end

  context "with a valid discount value" do
    it "should return the correct discount value" do
      expect(subject.discount_value(10)).to eq(1.0) # 9.99 * (10 / 100.0) => 0.999 => round(2) => 1.0
    end
  end

  context "with an invalid discount value" do
    it "should return nil" do
      expect(subject.discount_value(-1)).to be_nil
      expect(subject.discount_value(110)).to be_nil
    end
  end
end
