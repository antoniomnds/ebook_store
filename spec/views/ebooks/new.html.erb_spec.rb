require 'rails_helper'

RSpec.describe "ebooks/new", type: :view do
  it "has a heading with text 'New ebook'" do
    stub_template "ebooks/_form" => "Form partial"

    render

    expect(rendered).to have_css("h1", text: "New ebook")
  end

  it "renders a form partial" do
    expect_partial_to_be_rendered "ebooks/_form"
  end

  it "has a link to go back to the ebooks listing" do
    stub_template "ebooks/_form" => "Form partial"

    render

    expect(rendered).to have_link("Back to ebooks", href: ebooks_path)
  end
end
