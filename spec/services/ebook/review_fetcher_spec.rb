# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ebook::ReviewFetcher do
  let(:ebook) { create(:ebook) }
  let(:mocked_response) { Faker::Lorem.sentence }

  describe "#call" do
    it "returns the review data from the API" do
      allow(Api::NewYorkTimes::ReviewFetcher).to receive(:call).with(ebook).and_return(mocked_response)

      expect(Api::NewYorkTimes::ReviewFetcher.call(ebook)).to be(mocked_response)
    end
  end
end
