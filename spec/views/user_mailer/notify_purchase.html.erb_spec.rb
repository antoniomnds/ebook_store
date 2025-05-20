require 'rails_helper'

RSpec.describe "user_mailer/notify_purchase", type: :view do
  it "greets the user" do
    user = instance_double(User, username: "test")
    ebook = instance_double(Ebook, title: "What is a thing?", price: 10.to_d, discount_value: 1)
    assign(:user, user)
    assign(:ebook, ebook)

    render

    expect(rendered).to include("Hi #{user.username}!")
  end

  it "thanks for buying the ebook" do
    ebook = instance_double(Ebook, title: "What is a thing?", price: 10.to_d, discount_value: 1)
    assign(:user, User.new)
    assign(:ebook, ebook)

    render

    expect(rendered).to include("Thank you for purchasing \"#{ebook.title}\"")
  end

  it "includes info on the discount applied to the purchase of the ebook" do
    ebook = instance_double(Ebook, title: "What is a thing?", price: 10.to_d, discount_value: 1)
    discount = 10
    assign(:user, User.new)
    assign(:ebook, ebook)
    assign(:discount, discount)

    render

    expect(rendered).to include("You have gotten #{discount}% off the original price")
  end

  it "includes info on the discount value gotten in the purchase of the ebook" do
    ebook = instance_double(Ebook, title: "What is a thing?", price: 10.to_d)
    discount = 10
    allow(ebook).to receive(:discount_value).with(discount).and_return(1)
    assign(:user, User.new)
    assign(:ebook, ebook)
    assign(:discount, discount)

    render

    content = Nokogiri.HTML(rendered).content.squish # removes extra whitespaces

    expect(content).to include("which corresponds to a discount of #{ebook.discount_value(discount)}€!")
  end
end
