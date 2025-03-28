require 'rails_helper'

RSpec.describe "Registrations", type: :system do
  include ActiveJob::TestHelper

  let(:user) { build(:user) }

  it "successfully signs up" do
    visit_sign_up

    expect_user_registered do
      register_user
    end
  end

  def visit_sign_up
    visit root_path
    click_link "Sign up"
  end

  def register_user
    fill_in "Username", with: user.username
    fill_in "Email", with: user.email
    fill_in "New password", with: user.password
    fill_in "New password confirmation", with: user.password
    click_button "Submit"
  end

  def expect_user_registered(&block)
    perform_enqueued_jobs do # Forces `deliver_later` to run synchronously
      expect {
        yield # block is not optional

      }.to change(User, :count).by(1)

      expect(page).to have_content "User was successfully created."
      expect(current_path).to eq(root_path)
      expect(page).to have_content "Welcome to the Ebook Store!"
    end

    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to include(user.email)
      expect(mail.subject).to eq("Welcome to the Ebook Store!")
    end
  end
end
