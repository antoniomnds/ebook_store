require 'rails_helper'

RSpec.describe "Pages Request", type: :request do
  it "can access the homepage" do
    get root_url

    expect(response).to have_http_status(200)
  end
end
