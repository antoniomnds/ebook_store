require 'rails_helper'

RSpec.describe "ebooks/show", type: :view do
  it "renders the ebook partial" do
    # this is a unit test, helper methods should be stubbed
    allow(view).to receive(:edit_ebook_button).and_return("Edit ebook button")
    allow(view).to receive(:delete_ebook_button).and_return("Delete ebook button")
    assign(:ebook, build_stubbed(:ebook))

    expect_partial_to_be_rendered "ebooks/_ebook"
  end

  it "has a link to go back" do
    # this is a unit test, helper methods should be stubbed
    allow(view).to receive(:edit_ebook_button).and_return("Edit ebook button")
    allow(view).to receive(:delete_ebook_button).and_return("Delete ebook button")
    stub_template "ebooks/_ebook" => "Ebook partial"
    assign(:ebook, build_stubbed(:ebook))

    render

    expect(rendered).to have_link("Back to ebooks", href: ebooks_path)
  end
end
