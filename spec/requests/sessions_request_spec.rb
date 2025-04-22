require 'rails_helper'

RSpec.describe "Sessions Request", type: :request do
  let(:user) { create(:user) }

  it "allows access to sessions#new" do
    get new_session_path

    expect(response).to have_http_status(200)
  end

  context "with invalid credentials" do
    it "does not create a session" do
      post sessions_path, params: { email: user.email, password: "" }

      expect(response).to have_http_status(422) # Unprocessable Entity
    end
  end

  context "with a disabled user" do
    it "does not create a session" do
      user.disable!

      post sessions_path, params: { email: user.email, password: user.password }

      expect(response).to redirect_with_flash_to(new_session_url, :alert)
    end
  end

  context "with valid credentials" do
    it "creates a session and redirects back" do
      back_url = ebooks_url

      post sessions_path, params: { email: user.email, password: user.password, back_url: back_url }

      expect(response).to redirect_with_flash_to(back_url, :notice)
    end
  end

  context "when logging out" do
    it "destroys the session" do
      sign_in_request_as user

      delete session_path(user)

      expect(session.has_key?(:current_user_id)).to be(false)
    end

    it "redirects to the homepage" do
      sign_in_request_as user

      delete session_path(user)

      expect(response).to redirect_with_flash_to(root_url, :notice)
    end
  end
end
