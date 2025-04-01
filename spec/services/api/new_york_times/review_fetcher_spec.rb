# frozen_string_literal: true

require 'rails_helper'
require 'support/api_support'

RSpec.describe ::Api::NewYorkTimes::ReviewFetcher do
  let(:ebook) { build(:ebook) }

  describe "#call" do
    it "fetches a review from the API" do
      stub = stub_review_request(title: ebook.title)

      expect(::Api::NewYorkTimes::ReviewFetcher.call(title: ebook.title)).to eq(mocked_review["results"])
      expect(stub).to have_been_requested
    end
  end
end
