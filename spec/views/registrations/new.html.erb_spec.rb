require 'rails_helper'

RSpec.describe "registrations/new", type: :view do
  it "has a heading with text 'Sign up'" do
    stub_template "registrations/_form" => "Form partial"

    render

    expect(rendered).to have_css("h1", text: "Sign up")
  end

  it "renders the registrations form partial" do
    expect_partial_to_be_rendered "registrations/_form"
  end

  it "has a link to the homepage" do
    stub_template "registrations/_form" => "Form partial"

    render

    expect(rendered).to have_link("Back to home", href: root_path)
  end
end
