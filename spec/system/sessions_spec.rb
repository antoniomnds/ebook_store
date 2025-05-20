require 'rails_helper'

RSpec.describe "Session management", type: :system do
  let(:user) { create(:user) }

  describe "Logins" do
    it "successfully logs in" do
      sign_in_as(user)

      expect_user_signed_in
    end

    def expect_user_signed_in
      expect(page).to have_content("You have successfully logged in.")
      expect(page).to have_content("Welcome to the Ebook Store!")
      expect(page).to have_current_path("/")
    end

    it "fails to log in due to wrong password" do
      visit_login_page

      fill_login_form(password: "")

      expect_wrong_password
    end

    def visit_login_page
      visit root_path

      click_link "Log in"
    end

    def fill_login_form(password:)
      fill_in "Email", with: user.email
      fill_in "Password", with: password
      click_button "Login"
    end

    def expect_wrong_password
      expect(page).to have_content("The email or password you entered is incorrect.")
      expect(page).to have_current_path("/sessions")
    end

    context "when the user's password is expired" do
      before do
        user.update!(password_expires_at: Date.yesterday) # expire password
      end

      it "fails to log in" do
        visit_login_page

        fill_login_form(password: user.password)

        expect_password_expired
      end

      def expect_password_expired
        expect(page).to have_content("Your password has expired. Please update your password.")
        expect(page).to have_current_path("/users/#{user.id}/edit")
      end
    end

    context "when the user is disabled" do
      before do
        user.disable!
      end

      it "fails to log in" do
        visit_login_page

        fill_login_form(password: user.password)

        expect_user_removed
      end

      def expect_user_removed
        expect(page).to have_content("Your account has been removed.")
        expect(page).to have_current_path("/sessions/new")
      end
    end
  end

  describe "Logouts" do
    it "enables the user to log out", js: true do
      sign_in_as user

      logout_user

      expect_user_logged_out
    end

    def logout_user
      accept_confirm "Are you sure you want to logout?" do
        click_button("Log out") # action that will trigger the system modal
      end
    end

    def expect_user_logged_out
      expect(page).to have_current_path("/")
      expect(page).to have_content("You have successfully logged out.")
    end
  end
end
