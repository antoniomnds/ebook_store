require 'rails_helper'

RSpec.describe "pages/home", type: :view do
  it "has a heading with a welcome message" do
    render

    expect(rendered).to have_css("h1", text: "Welcome to the Ebook Store!")
  end

  it "has a link to the users listing" do
    render

    expect(rendered).to have_link("View Users", href: users_path)
  end

  it "has a link to the ebooks listing" do
    render

    expect(rendered).to have_link("View Ebooks", href: ebooks_path)
  end
end
