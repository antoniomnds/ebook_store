require "rails_helper"

RSpec.describe RegistrationsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/registrations/new").to route_to("registrations#new")
    end

    it "routes to #create" do
      expect(post: "/registrations").to route_to("registrations#create")
    end
  end
end
