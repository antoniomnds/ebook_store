require 'rails_helper'

RSpec.describe "layouts/_navbar", type: :view do
  it "has a navbar" do
    render

    expect(rendered).to have_css("nav")
  end

    it "has a link with the app's name" do
    render

    expect(rendered).to have_link("Ebook Store", href: "#")
  end

  it "has a link to the homepage" do
    render

    expect(rendered).to have_link("Home", href: root_path)
  end

  it "has a link to the ebooks listing" do
    render

    expect(rendered).to have_link("Ebooks", href: ebooks_path)
  end

  it "has a link to the users listing" do
    render

    expect(rendered).to have_link("Users", href: users_path)
  end

  context "when not logged in" do
    it "has a link to sign up" do
      render

      expect(rendered).to have_link("Sign up", href: new_registration_path)
    end

    it "has a link to sign in" do
      render

      expect(rendered).to have_link("Log in", href: new_session_path)
    end
  end

  context "when logged in" do
    it "has a greeting message" do
      user = instance_double(User, username: "test")
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:logged_in?).and_return(true)

      render

      expect(rendered).to have_link("Welcome, #{user.username}!", href: "#")
    end

    it "has a link to edit the user" do
      user = instance_double(User, username: "test")
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:logged_in?).and_return(true)

      render

      expect(rendered).to have_link("Edit profile", href: edit_user_path(user))
    end

    it "has a link to the user's ebooks" do
      user = instance_double(User, username: "test")
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:logged_in?).and_return(true)

      render

      expect(rendered).to have_link("My ebooks", href: my_ebooks_ebooks_path)
    end

    it "has a button to logout" do
      user = instance_double(User, username: "test")
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:logged_in?).and_return(true)

      render

      aggregate_failures do
        expect(rendered).to have_field(type: "hidden", name: "_method", with: "delete")
        expect(rendered).to have_button("Log out", type: "submit")
      end
    end
  end
end
