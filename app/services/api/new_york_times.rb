class Api::NewYorkTimes
  BASE_URL = "https://api.nytimes.com/svc/books/v3/reviews.json".freeze

  class << self
    def fetch_summary(query_params)
      new.fetch_summary(query_params)
    end
  end

  attr_accessor :api_key

  def initialize
    @api_key = ENV["NYT_API_KEY"]
  end

  def fetch_summary(params)
    base_url = "https://api.nytimes.com/svc/books/v3/reviews.json"
    query_params = params.merge("api-key": api_key)
    query = URI.encode_www_form(query_params)
    url = URI("#{ base_url }?#{ query }")

    response = Net::HTTP.get_response(url)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)

      data["results"]
    else
      error_message = %Q(
        Error: Unable to retrieve reviews from NY Times API.
        HTTP response message: #{ response.message }
        HTTP response body: #{ response.body }
      )
      Rails.logger.error(error_message)
      nil
    end
  end
end
