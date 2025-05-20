require 'rails_helper'

RSpec.describe "ebooks/_ebook", type: :view do
  it "has the ebook's cover image" do
    ebook = build_stubbed(:ebook, :live)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:cover_image_tag).with(ebook).and_return("Cover image")
    allow(view).to receive(:ebook_status_tag).with(ebook).and_return(ebook.status)
    allow(view).to receive(:purchase_button).with(ebook).and_return("Purchase button")
    summary_stub = "Lorem ipsum"
    allow(view).to receive(:ebook_summary_tag).with(summary_stub).and_return(summary_stub)
    assign(:summary, summary_stub)

    render locals: { ebook: ebook }

    expect(rendered).to include("Cover image")
  end

  it "has the ebook's status information" do
    ebook = build_stubbed(:ebook)
    # this is a unit test, helper methods should be stubbed
    allow(view).to receive(:cover_image_tag).with(ebook).and_return("Cover image")
    allow(view).to receive(:ebook_status_tag).with(ebook).and_return(ebook.status)
    allow(view).to receive(:purchase_button).with(ebook).and_return("Purchase button")
    summary_stub = "Lorem ipsum"
    allow(view).to receive(:ebook_summary_tag).with(summary_stub).and_return(summary_stub)
    assign(:summary, summary_stub)

    render locals: { ebook: ebook }

    expect(rendered).to include(ebook.status)
  end

  it "has a button to purchase the ebook" do
    ebook = build_stubbed(:ebook)
    # this is a unit test, helper methods should be stubbed
    allow(view).to receive(:cover_image_tag).with(ebook).and_return("Cover image")
    allow(view).to receive(:ebook_status_tag).with(ebook).and_return(ebook.status)
    allow(view).to receive(:purchase_button).with(ebook).and_return("Purchase button")
    summary_stub = "Lorem ipsum"
    allow(view).to receive(:ebook_summary_tag).with(summary_stub).and_return(summary_stub)
    assign(:summary, summary_stub)

    render locals: { ebook: ebook }

    expect(rendered).to include("Purchase button")
  end

  it "has the ebook's summary" do
    ebook = build_stubbed(:ebook)
    # this is a unit test, helper methods should be stubbed
    allow(view).to receive(:cover_image_tag).with(ebook).and_return("Cover image")
    allow(view).to receive(:ebook_status_tag).with(ebook).and_return(ebook.status)
    allow(view).to receive(:purchase_button).with(ebook).and_return("Purchase button")
    summary_stub = "Lorem ipsum"
    allow(view).to receive(:ebook_summary_tag).with(summary_stub).and_return(summary_stub)
    assign(:summary, summary_stub)

    render locals: { ebook: ebook }

    expect(rendered).to include(summary_stub)
  end

  it "shows the ebook's attributes" do
    ebook = build_stubbed(:ebook)
    allow(view).to receive(:cover_image_tag).with(ebook).and_return("Cover image")
    allow(view).to receive(:ebook_status_tag).with(ebook).and_return(ebook.status)
    allow(view).to receive(:purchase_button).with(ebook).and_return("Purchase button")
    summary_stub = "Lorem ipsum"
    allow(view).to receive(:ebook_summary_tag).with(summary_stub).and_return(summary_stub)
    assign(:summary, summary_stub)

    render locals: { ebook: ebook }

    content = Nokogiri::HTML(rendered).content

    aggregate_failures do
      ebook.attributes.reject do |k, _|
        %w[id status created_at updated_at user_id].include?(k)
      end.each do |k, v|
        if v.is_a?(ActiveSupport::TimeWithZone)
          v = v.strftime("%m/%d/%Y")
        end
        expect(content.upcase).to include(k.humanize.upcase) unless k == "title"
        expect(content).to include(v.to_s)
      end
    end
  end
end
