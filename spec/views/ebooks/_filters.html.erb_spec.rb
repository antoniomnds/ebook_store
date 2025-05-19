require 'rails_helper'

RSpec.describe "ebooks/_filters", type: :view do
  it "has a form" do
    assign(:tags, Tag.none)
    assign(:users, User.none)

    render locals: { url: ebooks_url }

    expect(rendered).to have_css("form")
  end

  it "has a select for filtering by ebook tags" do
    tags = build_stubbed_pair(:tag)
    assign(:tags, tags)
    assign(:users, User.none)

    render locals: { url: ebooks_url }

    aggregate_failures do
      expect(rendered).to have_css("label", text: "Tags")
      expect(rendered).to have_select("Tags", options: tags.pluck(:name).unshift(""))
    end
  end

  it "has a select for filtering by ebook owner" do
    users = build_stubbed_pair(:user)
    assign(:tags, Tag.none)
    assign(:users, users)

    render locals: { url: ebooks_url }

    aggregate_failures do
      expect(rendered).to have_css("label", text: "Users")
      expect(rendered).to have_select("Users", options: users.pluck(:username).unshift(""))
    end
  end

  it "has a button to filter the list of ebooks" do
    assign(:tags, Tag.none)
    assign(:users, User.none)

    render locals: { url: ebooks_url }

    expect(rendered).to have_css("input[type='submit'][name='commit'][value='Filter']")
  end

  it "has a button to reset the filtering" do
    assign(:tags, Tag.none)
    assign(:users, User.none)

    render locals: { url: ebooks_url }

    expect(rendered).to have_link("Reset", href: ebooks_url)
  end
end
