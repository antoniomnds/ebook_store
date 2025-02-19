require 'rails_helper'

RSpec.describe "Application Request", type: :request do
  let(:user) { create(:user) }

  def login_user
    post sessions_path(email: user.email, password: user.password)
    follow_redirect!
  end

  describe "handling NotFound exceptions" do
    context "when accessing a non-existent ebook" do
      it "responds not found" do
        get ebook_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when accessing a non-existent user" do
      before do
        login_user # authenticate the user since user_path is a protected route
      end

      it "responds not found" do
        get user_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "handling a user not logged in" do
    context "when navigating to a protected route" do
      it "redirects to the login page" do
        get users_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "handling an user with an expired password" do
    before do
      user.update!(password_expires_at: Date.yesterday)
      login_user # authenticate the user since users_path is a protected route
    end

    context "when navigating to a protected route" do
      it "redirects to the page to edit the password" do
        get users_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(edit_user_path(user))
      end
    end
  end

  describe "handling a disabled user" do
    before do
      login_user
      user.disable!
    end

    it "denies access to protected routes and logs out the user" do
      aggregate_failures do
        get users_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)

        # the following requests will fail as the user is not logged in
        get user_path(user)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)

        get edit_user_path(user)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)

        get new_ebook_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)

        get my_ebooks_ebooks_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
