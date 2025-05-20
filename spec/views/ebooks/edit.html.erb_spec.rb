require 'rails_helper'

RSpec.describe "ebooks/edit", type: :view do
  it "has a heading with text 'Editing ebook'" do
    stub_template "ebooks/_form" => "Form partial"

    render

    expect(rendered).to have_css("h1", text: "Editing ebook")
  end

  it "renders a form partial" do
    expect_partial_to_be_rendered("ebooks/_form")
  end
end
