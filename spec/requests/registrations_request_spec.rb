require 'rails_helper'

RSpec.describe "Registrations Request", type: :request do
  include ActiveJob::TestHelper

  it "allows access to registrations#new" do
    get new_registration_path

    expect(response).to have_http_status(200)
  end

  context "with an invalid user" do
    it "does not create the user" do
      expect do
        post registrations_path, params: { user: attributes_for(:user, email: "") }
      end.not_to change(User, :count)

      expect(response).to have_http_status(422)
    end
  end

  context "with a valid user" do
    it "creates a user and redirects to the homepage" do
      expect do
        post registrations_path, params: { user: attributes_for(:user) }
      end.to change(User, :count).by(1)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_url)
    end

    it "sends a welcome email to the user" do
      perform_enqueued_jobs do  # Forces `deliver_later` to run synchronously
        expect {
          post registrations_path, params: { user: attributes_for(:user) }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)  # Verify email is sent
      end
    end
  end
end
