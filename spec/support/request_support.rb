module RequestSupport
  def stubbed_request(method, params, headers = {}, body = {})
    query_params = params.merge("api-key": ENV["NYT_API_KEY"])
    url = URI("#{ Api::NewYorkTimes::ReviewFetcher::BASE_URL }?#{ URI.encode_www_form(query_params) }")
    headers.merge!(
      {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    )

    stub_request(method, url).to_return_json(body: body.to_json, headers:)
  end
end

RSpec.configure do |config|
  config.include RequestSupport
end
