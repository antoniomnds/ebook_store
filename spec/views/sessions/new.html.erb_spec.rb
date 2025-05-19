require 'rails_helper'

RSpec.describe "sessions/new", type: :view do
  it "has a heading with text 'Login" do
    stub_template "sessions/_form" => "Form partial"

    render

    expect(rendered).to have_css("h1", text: "Login")
  end

  it "renders the form's partial" do
    expect_partial_to_be_rendered "sessions/_form"
  end
end
