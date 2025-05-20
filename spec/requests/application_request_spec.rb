require 'rails_helper'

RSpec.describe "Application Request", type: :request do
  let(:user) { create(:user) }

  describe "#login" do
    it "stores the user id in the session" do
      sign_in_request_as user

      expect(session[:current_user_id]).to eq(user.id)
    end
  end

  describe "#logout" do
    it "clears the user id from the session" do
      sign_in_request_as user

      delete session_path(user)

      expect(session[:current_user_id]).to be_nil
    end
  end

  describe "handling a disabled user" do
    before do
      sign_in_request_as user
      user.disable!
    end

    it "logs out the user" do
      expect { get users_path }.to change { session.has_key?("current_user_id") }.from(true).to(false)
    end

    it "redirects to the login page" do
      get users_path

      expect(response).to redirect_with_flash_to(new_session_url, :alert)
    end
  end

  describe "handling a user not logged in" do
    context "when navigating to a protected route" do
      it "redirects to the login page" do
        get users_path

        expect(response).to redirect_with_flash_to(new_session_url, :alert)
      end
    end
  end

  describe "handling an user with an expired password" do
    before do
      user.update!(password_expires_at: Date.yesterday)
      sign_in_request_as user # authenticate the user since users_path is a protected route
    end

    context "when navigating to a protected route" do
      it "redirects to the page to edit the password" do
        get users_path

        expect(response).to redirect_with_flash_to(edit_user_url(user), :alert)
      end
    end
  end

  it "loads the current user for authenticated requests" do
    sign_in_request_as user

    get users_path # request to a protected route

    expect(response).to have_http_status(:success) # user was loaded
  end

  describe "handling NotFound exceptions" do
    context "when accessing a non-existent ebook" do
      it "responds not found" do
        get ebook_path(id: 0)

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when accessing a non-existent user" do
      it "responds not found" do
        sign_in_request_as user # authenticate the user since user_path is a protected route

        get user_path(id: 0)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
