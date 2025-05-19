require 'rails_helper'

RSpec.describe "sessions/_form", type: :view do
  it "has a form" do
    render

    expect(rendered).to have_css("form")
  end

  it "has an input for email and password" do
    render

    aggregate_failures do
      %w[ email password ].each do |attr|
        expect(rendered).to have_field(attr)
      end
    end
  end

  it "has an input to submit the form" do
    render

    expect(rendered).to have_css("input[type='submit'][name='commit'][value='Login']")
  end
end
