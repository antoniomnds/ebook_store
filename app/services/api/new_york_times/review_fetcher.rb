module Api
  module NewYorkTimes
    class ReviewFetcher < ApiService
      BASE_URL = "https://api.nytimes.com/svc/books/v3/reviews.json".freeze

      attr_accessor :api_key, :params

      def initialize(params)
        @api_key = ENV["NYT_API_KEY"]
        @params = params
      end

      def call
        query_params = params.merge("api-key": api_key)
        query = URI.encode_www_form(query_params)
        uri = URI("#{ BASE_URL }?#{ query }")
        fail_message = "Unable to retrieve reviews from NY Times API."

        make_request(uri, :get, fail_message) do |data|
          data["results"]
        end
      end
    end
  end
end
