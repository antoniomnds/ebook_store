require 'rails_helper'

RSpec.describe "/ebooks/_form", type: :view do
  it "has a form" do
    ebook = build_stubbed(:ebook)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(ebook).and_return(nil)
    allow(view.request).to receive(:referer).and_return(ebooks_path)
    assign(:ebook, ebook)

    render

    expect(rendered).to have_css("form")
  end

  it "has an input for each attribute" do
    ebook = build_stubbed(:ebook)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(ebook).and_return(nil)
    allow(view.request).to receive(:referer).and_return(ebooks_path)
    assign(:ebook, ebook)

    render

    aggregate_failures do
      ebook.attributes.reject do |k, _|
        %w[id created_at updated_at user_id].include?(k)
      end.each do |k, _|
        expect(rendered).to have_field("ebook[#{k}]")
      end
    end
  end

  it "has an input to submit the form" do
    ebook = build_stubbed(:ebook)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(ebook).and_return(nil)
    allow(view.request).to receive(:referer).and_return(ebooks_path)
    assign(:ebook, ebook)

    render

    expect(rendered).to have_css("input[type='submit'][name='commit'][value='Update Ebook']")
  end

  it "has a link to go to the ebook page" do
    ebook = build_stubbed(:ebook)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(ebook).and_return(nil)
    allow(view.request).to receive(:referer).and_return(ebooks_path)
    assign(:ebook, ebook)

    render

    expect(rendered).to have_link("Cancel", href: request.referer)
  end
end
