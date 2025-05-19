require 'rails_helper'

RSpec.describe "user_mailer/notify_ebook_statistics", type: :view do
  let(:ebook) do
    instance_double(Ebook,
                    title: "Lorem ipsum",
                    sales: rand(1000),
                    views: rand(100000),
                    preview_downloads: rand(100)
    )
  end

  it "greets the user" do
    user = instance_double(User, username: "john_doe")
    assign(:user, user)
    assign(:ebook, Ebook.new)

    render

    expect(rendered).to include("Hi #{user.username}!")
  end

  it "contains the ebook's title" do
    assign(:user, User.new)
    assign(:ebook, ebook)

    render

    expect(rendered).to include(ebook.title)
  end

  it "says how many sales the ebook has" do
    assign(:user, User.new)
    assign(:ebook, ebook)

    render

    expect(rendered).to include("purchased #{ebook.sales} times")
  end

  it "says how many views the ebook has" do
    assign(:user, User.new)
    assign(:ebook, ebook)

    render

    expect(rendered).to include("viewed #{ebook.views} times")
  end

  it "says how many times the ebook's preview has been downloaded" do
    assign(:user, User.new)
    assign(:ebook, ebook)

    render

    expect(rendered).to include("downloaded #{ebook.preview_downloads} times")
  end
end
