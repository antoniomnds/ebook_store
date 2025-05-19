require 'rails_helper'

RSpec.describe "user_mailer/welcome", type: :view do
  it "greets the user" do
    user = build(:user)
    assign(:user, user)

    render

    expect(rendered).to include("Hi #{user.username}!")
  end

  it "contains the username and email of the user" do
    user = build(:user)
    assign(:user, user)

    render

    aggregate_failures do
      expect(rendered).to include(user.username)
      expect(rendered).to include(user.email)
    end
  end

  it "thanks the user for joining" do
    assign(:user, User.new)

    render

    expect(rendered).to include("Thanks for joining")
  end
end
