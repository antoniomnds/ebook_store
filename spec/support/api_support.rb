module ApiSupport
  def mocked_review
    { "results" => [ { "summary" => "Lorem ipsum" } ] }
  end

  def stub_review_request(params)
    query_params = params.merge("api-key": ENV["NYT_API_KEY"])
    url = URI("#{ Api::NewYorkTimes::ReviewFetcher::BASE_URL }?#{ URI.encode_www_form(query_params) }")
    headers =
      {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }

    stub_request(:get, url).to_return_json(body: mocked_review.to_json, headers:)
  end
end
