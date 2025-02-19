require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  def login_user
    post sessions_path(email: user.email, password: user.password)
    follow_redirect!
  end

  it "allows access to sessions#new" do
    get new_session_path
    expect(response).to have_http_status(200)
  end

  context "with invalid credentials" do
    it "does not create a session" do
      post sessions_path(email: user.email, password: "", back_url: ebooks_url)

      expect(response).to have_http_status(422)
    end
  end

  context "with a disabled user" do
    it "does not create a session" do
      user.disable!
      post sessions_path(email: user.email, password: user.password)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_path)
    end
  end

  context "with valid credentials" do
    it "creates a session and redirects back" do
      back_url = ebooks_url
      post sessions_path(email: user.email, password: user.password, back_url: back_url)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(back_url)
    end
  end

  context "when logging out" do
    it "destroys the session and redirects to the homepage" do
      login_user
      delete session_path(user)
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
      # no longer can access a route that requires authentication
      get users_path
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_path)
    end
  end
end
