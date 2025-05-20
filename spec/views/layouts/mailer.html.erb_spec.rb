require 'rails_helper'

RSpec.describe "layouts/mailer", type: :view do
  it "is a HTML document" do
    render

    expect(rendered).to have_css("html")
  end

  it "has a head element" do
    render

    expect(rendered).to have_css("head", visible: false)
  end

  it "has a meta tag with content type and charset configuration" do
    render

    expect(rendered).to include("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">")
  end

  it "yields view content" do
    # provide a view content and wrap it in the mailer layout
    render inline: "<h2>Dummy View Content</h2>", layout: self.class.top_level_description

    expect(rendered).to include("Dummy View Content")
  end

  it "has a footer" do
    render

    expect(rendered).to have_css("footer")
  end

  it "has a closing message" do
    render

    expect(rendered).to include("regards")
  end

  it "has a link to the ebook listing" do
    render

    expect(rendered).to have_link("Ebook Store", href: ebooks_url)
  end
end
