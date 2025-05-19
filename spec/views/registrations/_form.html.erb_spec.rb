require 'rails_helper'

RSpec.describe "registrations/_form", type: :view do
  it "has a form" do
    user = User.new
    # this is a unit test, helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(user).and_return(nil)
    assign(:user, user)

    render

    expect(rendered).to have_css("form")
  end

  it "has an input for each attribute" do
    user = User.new
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(user).and_return(nil)
    assign(:user, user)

    render

    aggregate_failures do
      user.attributes.keys.reject do |key|
        %w[id enabled password_digest password_expires_at admin disabled_at
           created_at updated_at].include?(key)
      end.concat(%w[ password password_confirmation ]).each do |attr|
        expect(rendered).to have_field("user[#{attr}]")
      end
    end
  end

  it "has an input to submit the form" do
    user = User.new
    # this is a unit test, helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(user).and_return(nil)
    assign(:user, user)

    render

    expect(rendered).to have_css("input[type='submit'][name='commit'][value='Submit']")
  end
end
