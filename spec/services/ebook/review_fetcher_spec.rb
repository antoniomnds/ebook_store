require "rails_helper"

RSpec.describe Ebook::ReviewFetcher do
  describe "#call" do
    it "returns the review data from the API" do
      ebook = build(:ebook)
      stub_review_request(title: ebook.title)

      expect(described_class.call(ebook)).to eq(mocked_review.dig("results", 0, "summary"))
    end
  end
end
