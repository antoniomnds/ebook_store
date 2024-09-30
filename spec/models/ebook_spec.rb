require 'rails_helper'
require 'support/shared_examples/model'
require 'support/shared_contexts/logging'

RSpec.describe Ebook, type: :model do
  subject { described_class.new(
    title: "Example Ebook",
    status: :live,
    price: 9.99,
    authors: "John Doe",
    genre: "Fiction",
    publisher: "Acme Publishing",
    publication_date: "2024-09-23",
    pages: 100,
    isbn: "349-35893523",
    user: User.new
  ) }

  include_context "logging"

  include_examples "model"

  it "has zero sales by default" do
    expect(subject.sales).to be_zero
  end

  it "has zero views by default" do
    expect(subject.views).to be_zero
  end

  it "has zero preview downloads by default" do
    expect(subject.preview_downloads).to be_zero
  end

  it "has a status that belongs to a predefined set of values" do
    expect(subject.status).to satisfy("be one of #{ Ebook.statuses.keys }") do |status|
      Ebook.statuses.keys.include?(status)
    end
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
                        isbn: "349-35893523",
                        sales: 0,
                        views: 0,
                        preview_downloads: 0,
                        user: be_a(User)
                      )}

  context "without a title" do
    it "should be invalid" do
      subject.title = nil
      expect(subject).not_to be_valid
    end
  end

  context "with a title less than four characters" do
    it "should be invalid" do
      subject.title = "A" * 3
      expect(subject).not_to be_valid
    end
  end

  context "without a status" do
    it "should be invalid" do
      subject.status = nil
      expect(subject).not_to be_valid
    end
  end

  context "without a price" do
    it "should be invalid" do
      subject.price = nil
      expect(subject).not_to be_valid
    end
  end

  context "without authors" do
    it "should be invalid" do
      subject.authors = nil
      expect(subject).not_to be_valid
    end
  end

  context "without a genre" do
    it "should be invalid" do
      subject.genre = nil
      expect(subject).not_to be_valid
    end
  end

  context "without a publisher" do
    it "should be invalid" do
      subject.publisher = nil
      expect(subject).not_to be_valid
    end
  end

  context "without a publication date" do
    it "should be invalid" do
      subject.publication_date = nil
      expect(subject).not_to be_valid
    end
  end

  context "without pages" do
    it "should be invalid" do
      subject.pages = nil
      expect(subject).not_to be_valid
    end
  end

  context "without an ISBN" do
    it "should be invalid" do
      subject.isbn = nil
      expect(subject).not_to be_valid
    end
  end

  context "without a user" do
    it "should be invalid" do
      subject.user = nil
      expect(subject).not_to be_valid
    end
  end

  context "with a price less than zero" do
    it "should be invalid" do
      subject.price = -1
      expect(subject).not_to be_valid
    end
  end

  context "with a publication date in the future" do
    it "should be invalid" do
      subject.publication_date = Date.tomorrow
      expect(subject).not_to be_valid
    end
  end

  context "with a publication date in the past" do
    it "should be valid" do
      subject.publication_date = Date.yesterday
      expect(subject).to be_valid
    end
  end

  context "with a valid discount value" do
    it "should return the correct discount value" do
      expect(subject.discount_value(10)).to eq(1.0) # 9.99 * (10 / 100.0) => 0.999 => round(2) => 1.0
    end
  end

  context "with an invalid discount value" do
    it "should return nil" do
      expect(subject.discount_value(110)).to be_nil
    end
  end
end
