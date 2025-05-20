require 'rails_helper'

RSpec.describe "ebooks/_list", type: :view do
  it "has a table" do
    assign(:ebooks, Ebook.none)

    render

    expect(rendered).to have_table(id: "ebooks")
  end

  it "lists each ebook in the table body" do
    ebooks = build_stubbed_pair(:ebook, :with_tags)
    assign(:ebooks, ebooks)

    render

    expect_ebooks_listing(ebooks)
  end

  def expect_ebooks_listing(ebooks)
    cell_selector = 'tbody>tr>td'

    ebooks.each do |ebook|
      expect(rendered).to have_css(cell_selector, text: ebook.title)
      expect(rendered).to have_css(cell_selector, text: ebook.price)
      expect(rendered).to have_css(cell_selector, text: ebook.authors)
      ebook.tags.each do |tag|
        expect(rendered).to have_css("#{cell_selector}>span", text: tag.name)
      end
      expect(rendered).to have_link("Show", href: ebook_path(ebook))
    end
  end
end
