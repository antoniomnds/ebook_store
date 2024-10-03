require 'rails_helper'
require 'support/shared_contexts/logging'
require 'support/shared_examples/model'

RSpec.describe User, type: :model do
  subject(:user) do
    described_class.new(username: "test", email: "test@example.com", password: "password")
  end

  include_context "logging"

  include_examples "model"

  it { is_expected.to be_enabled }

  it { is_expected.not_to be_is_admin }

  it { is_expected.to be_active }

  it { is_expected.to have_attributes(username: "test", email: "test@example.com", password: "password", enabled: true, is_admin: false) }

  context "validation tests" do
    describe "#username" do
      it "is required" do
        user.username = nil
        user.valid?
        expect(user.errors[:username].first).to match(/blank/)
      end
    end

    describe "#email" do
      it "is required" do
        user.email = nil
        user.valid?
        expect(user.errors[:email].first).to match(/blank/)
        expect(user.errors[:email].last).to match(/not an email/)
      end

      it "is unique" do
        another_user = User.create(username: "The Other", email: user.email, password: "password")
        user.valid?
        expect(user.errors[:email].first).to match(/already been taken/)
      end

      context "with an invalid email" do
        it "should be invalid" do
          user.email = "invalid_email"
          user.valid?
          expect(user.errors[:email].first).to match(/not an email/)
        end
      end
    end

    describe "#password" do
      it "is required" do
        user.password = nil
        user.valid?
        expect(user.errors[:password].first).to match(/blank/)
      end
    end
  end

  describe "#authenticate method" do
    before(:context) do
      puts("Initializing User#authenticate test suite")
    end

    after(:context) do
      puts("Finalized User#authenticate test suite")
    end

    context "with correct password" do
      it "should return the user" do
        expect(user.authenticate("password")).to be(user)
      end
    end

    context "with incorrect password" do
      it "should return false" do
        expect(user.authenticate("incorrect")).to be(false)
      end
    end
  end

  it "can respond to the deactivate! method with no arguments" do
    expect(user).to respond_to(:deactivate!).and respond_to(:deactivate!).with(0).arguments
  end

  describe "#deactivate! method" do
    before do
      user.deactivate!
    end

    it "should inactivate the user" do
      expect(user).not_to be_active
    end

    it "should update the username" do
      expect(user.username).to start_with("deleted-user-")
      expect(user.username).to match(/\Adeleted-user-\d+\z/)
    end

    it "should update the email" do
      expect(user.email).to end_with("@deleted-user")
      expect(user.email).to match(/\A\d+@deleted-user\z/)
    end

    it "should set the deactivated_at timestamp" do
      expect(user.deactivated_at).to_not be_nil
    end

    it "does not raise an error" do
      expect { user.deactivate! }.not_to raise_error
    end
  end
end
