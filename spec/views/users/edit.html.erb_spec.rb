require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  it "has a heading with text 'Edit your profile'" do
    stub_template "users/_form" => "Form partial"

    render

    expect(rendered).to have_css("h1", text: "Edit your profile")
  end

  it "renders the user's form" do
    stub_template "users/_form" => "Form partial"

    render

    expect(rendered).to include("Form partial")
  end
end
