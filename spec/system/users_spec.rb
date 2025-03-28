require 'rails_helper'
require 'support/login_support'

RSpec.describe "Users management", type: :system do
  describe "authenticated access to users" do
    let(:user) { create(:user) }

    before do
      sign_in_as user
    end

    it "enables accessing the users listing from the homepage" do
      visit_users_page

      expect_users_page
    end

    def visit_users_page
      visit root_path

      click_link "View Users"
    end

    def expect_users_page
      expect(page).to have_current_path(users_path)
      expect(page).to have_css("table#users")
    end

    it "enables accessing an user from the users page" do
      visit_user_page(user)

      expect_user_page(user)
    end

    def visit_user_page(user)
      visit users_path

      within "#user_#{user.id}" do
        click_link "View profile"
      end
    end

    def expect_user_page(user)
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content(user.username)
    end

    it "enables accessing the user's form to edit the user" do
      visit_edit_user_page(user)

      expect_user_edit_page(user)
    end

    def visit_edit_user_page(user)
      visit user_path(user)

      within ".btn-group" do
        click_link "Edit profile"
      end
    end

    def expect_user_edit_page(user)
      expect(page).to have_current_path(edit_user_path(user))
      expect(page).to have_content("Edit your profile")
    end

    it "edits the user" do
      visit_edit_user_page(user)
      old_username = user.username

      edit_user(user)

      expect_edited_user(user.reload, old_username)
    end

    def edit_user(user)
      user_attr = attributes_for(:user)

      fill_user_form(user, user_attr)

      click_button "Update User"
    end

    def fill_user_form(user, user_attr)
      attach_file "Avatar", Rails.root.join("spec", "fixtures", "files", "avatar.jpg")
      fill_in "Username", with: user_attr[:username]
      fill_in "Email", with: user_attr[:email]
      fill_in "Current password", with: user.password
      fill_in "New password", with: user_attr[:password]
      fill_in "New password confirmation", with: user_attr[:password]
    end

    def expect_edited_user(user, old_username)
      expect_user_page(user)
      expect(user.username).not_to eq(old_username)
    end

    it "deletes the user", js: true do
      visit_user_page(user)

      delete_user

      expect_deleted_user
    end

    def delete_user
      accept_confirm "Are you sure? This action cannot be undone." do
        click_button "Delete account"
      end
    end

    def expect_deleted_user
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("User was successfully removed.")
    end

    it "cannot remove another user" do
      another_user = create(:user)
      visit_user_page(another_user)

      expect_disabled_delete_button
    end

    def expect_disabled_delete_button
      expect(page).to have_button("Delete account", disabled: true)
    end

    context "when an admin user" do
      it "can remove another user", js: true do
        user.update!(admin: true)
        another_user = create(:user)

        visit_user_page(another_user)

        delete_user

        expect_deleted_user
      end
    end
  end
end
