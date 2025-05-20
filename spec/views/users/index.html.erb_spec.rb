require 'rails_helper'

RSpec.describe "users/index", type: :view do
  it "has a heading with text 'Users'" do
    assign(:users, User.none)

    render

    expect(rendered).to have_css("h1", text: "Users")
  end

  it "has a table" do
    assign(:users, User.none)

    render

    expect(rendered).to have_table(id: "users")
  end

  it "lists each user in the table body" do
    users = build_stubbed_pair(:user)
    assign(:users, users)

    render

    expect_users_listing(users)
  end

  def expect_users_listing(users)
    cell_selector = 'tbody>tr>td'

    users.each do |user|
      expect(rendered).to have_css(cell_selector, text: user.username)
      expect(rendered).to have_css(cell_selector, text: user.email)
      expect(rendered).to have_link("View profile", href: user_path(user))
    end
  end
end
