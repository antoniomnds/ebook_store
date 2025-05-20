require 'rails_helper'

RSpec.describe "/ebooks/my_ebooks", type: :view do
  it "has a heading with text 'My Ebooks'" do
    assign(:ebooks, Ebook.none)
    stub_template "ebooks/_filters" => "Filters partial"

    render

    expect(rendered).to have_css("h1", text: "My Ebooks")
  end

  it "has a link to add a new ebook" do
    assign(:ebooks, Ebook.none)
    stub_template "ebooks/_filters" => "Filters partial"

    render

    expect(rendered).to have_link("New ebook", href: new_ebook_path)
  end

  it "renders the filters partial" do
    assign(:ebooks, Ebook.none)

    expect_partial_to_be_rendered "ebooks/_filters"
  end

  it "renders the ebook list partial" do
    assign(:ebooks, build_stubbed_pair(:ebook))
    stub_template "ebooks/_filters" => "Filters partial"

    expect_partial_to_be_rendered "ebooks/_list"
  end
end
