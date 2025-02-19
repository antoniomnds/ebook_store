# frozen_string_literal: true

require 'rails_helper'
require 'support/request_helper'

RSpec.describe ::Api::NewYorkTimes::ReviewFetcher do
  let(:ebook) { build(:ebook) }
  let(:mocked_review) { { results: [ { summary: Faker::Lorem.sentence } ] }.to_json }

  describe ".call" do
    it "fetches a review from the API" do
      stub = stubbed_request(:get, { title: ebook.title }, {}, mocked_review)

      expect(::Api::NewYorkTimes::ReviewFetcher.call(title: ebook.title)).to eq(mocked_review["results"])

      expect(stub).to have_been_requested
    end
  end
end
