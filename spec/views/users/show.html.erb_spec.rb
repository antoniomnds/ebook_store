require 'rails_helper'

RSpec.describe "users/show", type: :view do
  it "renders the user partial" do
    user = build_stubbed(:user)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:delete_user_button).with(user).and_return("delete user button")
    assign(:user, user)

    expect_partial_to_be_rendered "users/_user"
  end

  it "has a link to go back to the users listing" do
    user = build_stubbed(:user)
    stub_template "users/_user" => "User partial"
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:delete_user_button).with(user).and_return("delete user button")
    assign(:user, user)

    render

    expect(rendered).to have_link("Back to users", href: users_path)
  end

  it "has a link to edit the user" do
    user = build_stubbed(:user)
    assign(:user, user)
    stub_template "users/_user" => "User partial"
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:delete_user_button).with(user).and_return("delete user button")

    render

    expect(rendered).to have_link("Edit profile", href: edit_user_path(user))
  end
end
