require 'rails_helper'

RSpec.describe "ebooks/index", type: :view do
  it "has a heading with text 'Ebooks'" do
    assign(:ebooks, Ebook.none)
    stub_template "ebooks/_filters" => "Filters partial"

    render

    expect(rendered).to have_css("h1", text: "Ebooks")
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

  context "when there are ebooks" do
    it "renders the ebook listing partial" do
      ebooks = build_stubbed_pair(:ebook)
      assign(:ebooks, ebooks)
      stub_template "ebooks/_filters" => "Filters partial"

      expect_partial_to_be_rendered "ebooks/_list"
    end
  end

  context "when there are no ebooks" do
    it "shows an appropriate message together with a link to add one" do
      assign(:ebooks, Ebook.none)
      stub_template "ebooks/_filters" => "Filters partial"

      render

      aggregate_failures do
        expect(rendered).to have_css("div", text: "There are no ebooks available")
        expect(rendered).to have_link("Add one", href: new_ebook_path)
      end
    end
  end
end
