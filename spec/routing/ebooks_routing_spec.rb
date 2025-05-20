require "rails_helper"

RSpec.describe EbooksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/ebooks").to route_to("ebooks#index")
    end

    it "routes to #new" do
      expect(get: "/ebooks/new").to route_to("ebooks#new")
    end

    it "routes to #show" do
      expect(get: "/ebooks/1").to route_to("ebooks#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/ebooks/1/edit").to route_to("ebooks#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/ebooks").to route_to("ebooks#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/ebooks/1").to route_to("ebooks#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/ebooks/1").to route_to("ebooks#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/ebooks/1").to route_to("ebooks#destroy", id: "1")
    end

    it "routes to #purchase" do
      expect(post: "/ebooks/1/purchase").to route_to("ebooks#purchase", id: "1")
    end

    it "routes to #increment_views" do
      expect(patch: "/ebooks/1/increment_views").to route_to("ebooks#increment_views", id: "1")
    end

    it "routes to #my_ebooks" do
      expect(get: "ebooks/my_ebooks").to route_to("ebooks#my_ebooks")
    end
  end
end
