require 'rails_helper'

RSpec.describe "users/_form", type: :view do
  it "has a form" do
    user = build_stubbed(:user)
    assign(:user, user)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(user).and_return(nil)
    allow(view).to receive(:password_challenge_tag).and_return("Password challenge tag")
    allow(view).to receive(:user_enabled_tag).and_return("User enabled tag")
    allow(view.request).to receive(:referer).and_return(users_path)

    render

    expect(rendered).to have_css("form")
  end

  it "has an input for each attribute" do
    user = build_stubbed(:user)
    assign(:user, user)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(user).and_return(nil)
    allow(view).to receive(:password_challenge_tag).and_return("Password challenge tag")
    allow(view).to receive(:user_enabled_tag).and_return("User enabled tag")
    allow(view.request).to receive(:referer).and_return(users_path)

    render

    aggregate_failures do
      user.attributes.keys.reject do |key|
        %w[id enabled password_digest password_expires_at admin disabled_at
           created_at updated_at].include?(key)
      end.concat(%w[ avatar password_confirmation ]). each do |attr|
        expect(rendered).to have_field("user[#{attr}]")
      end
    end
  end

  it "has an input to submit the form" do
    user = build_stubbed(:user)
    assign(:user, user)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(user).and_return(nil)
    allow(view).to receive(:password_challenge_tag).and_return("Password challenge tag")
    allow(view).to receive(:user_enabled_tag).and_return("User enabled tag")
    allow(view.request).to receive(:referer).and_return(users_path)

    render

    expect(rendered).to have_css("input[type='submit'][name='commit'][value='Update User']")
  end

  it "has a link to go to the user page" do
    user = build_stubbed(:user)
    assign(:user, user)
    # this is a unit test, thus helper methods should be stubbed
    allow(view).to receive(:error_messages_for).with(user).and_return(nil)
    allow(view).to receive(:password_challenge_tag).and_return("Password challenge tag")
    allow(view).to receive(:user_enabled_tag).and_return("User enabled tag")
    allow(view.request).to receive(:referer).and_return(users_path)

    render

    expect(rendered).to have_link("Cancel", href: request.referer)
  end
end
