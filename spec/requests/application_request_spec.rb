require 'rails_helper'

RSpec.describe "Application Request", type: :request do
  describe "handling NotFound exceptions" do
    it "responds not found" do
      get ebook_path(id: 0)
      expect(response.status).to eq(404)
    end
  end
end
