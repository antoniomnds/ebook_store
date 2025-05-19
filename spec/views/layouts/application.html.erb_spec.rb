require 'rails_helper'

RSpec.describe "layouts/application", type: :view do
  it "is a HTML document" do
    stub_template "layouts/_navbar" => "Navbar partial"
    stub_template "layouts/_flash_messages" => "Flash messages partial"

    render

    expect(rendered).to have_css("html")
  end

  it "has a head element" do
    stub_template "layouts/_navbar" => "Navbar partial"
    stub_template "layouts/_flash_messages" => "Flash messages partial"

    render

    expect(rendered).to have_css("head", visible: false)
  end

  context "within the head element" do
    context "when the title is set in the view" do
      it "presents that title" do
        stub_template "layouts/_navbar" => "Navbar partial"
        stub_template "layouts/_flash_messages" => "Flash messages partial"
        title_stub = "Custom title"
        view.content_for(:title, title_stub)

        render

        expect(rendered).to have_css("title", text: title_stub, visible: false)
      end
    end

    context "when the title is not set in the view" do
      it "presents a default title" do
        stub_template "layouts/_navbar" => "Navbar partial"
        stub_template "layouts/_flash_messages" => "Flash messages partial"

        render

        expect(rendered).to have_css("title", text: "Ebook Store", visible: false)
      end
    end

    it "yields content for :head" do
      stub_template "layouts/_navbar" => "Navbar partial"
      stub_template "layouts/_flash_messages" => "Flash messages partial"
      meta_tag_stub = "<meta name=\"custom meta\" content=\"test\">".html_safe
      view.content_for(:head, meta_tag_stub)

      render

      expect(rendered).to include(meta_tag_stub)
    end
  end

  context "within the body element" do
    it "renders the navbar partial" do
      stub_template "layouts/_navbar" => "Navbar partial"
      stub_template "layouts/_flash_messages" => "Flash messages partial"

      render

      expect(rendered).to include("Navbar partial")
    end

    it "renders the flash messages partial" do
      stub_template "layouts/_navbar" => "Navbar partial"
      stub_template "layouts/_flash_messages" => "Flash messages partial"

      render

      expect(rendered).to include("Flash messages partial")
    end

    it "yields view content" do
      stub_template "layouts/_navbar" => "Navbar partial"
      stub_template "layouts/_flash_messages" => "Flash messages partial"

      # provide a view content and wrap it in the application layout
      render inline: "<h2>Dummy View Content</h2>", layout: self.class.top_level_description

      expect(rendered).to include("Dummy View Content")
    end
  end
end
