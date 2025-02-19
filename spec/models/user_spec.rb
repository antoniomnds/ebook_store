require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to be_enabled }

  it { is_expected.not_to be_admin }

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
        create(:user, email: user.email) # another user
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

    describe "#disabled?" do
      context "when the user is not enabled" do
        it "returns true" do
          user.enabled = false
          expect(user.disabled?).to eq(true)
        end
      end

      context "when the user is enabled" do
        it "returns false" do
          expect(user.disabled?).to eq(false)
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
    context "with correct password" do
      it "should return the user" do
        expect(user.authenticate(user.password)).to be(user)
      end
    end

    context "with incorrect password" do
      it "should return false" do
        expect(user.authenticate(Faker::Internet.password)).to be(false)
      end
    end
  end

  it "can respond to the disable! method with no arguments" do
    expect(user).to respond_to(:disable!).and respond_to(:disable!).with(0).arguments
  end

  describe "#disable! method" do
    before do
      user.disable!
    end

    it "should disable the user" do
      expect(user).not_to be_enabled
    end

    it "should update the username" do
      expect(user.username).to start_with("deleted-user-")
      expect(user.username).to match(/\Adeleted-user-\d+\z/)
    end

    it "should update the email" do
      expect(user.email).to end_with("@deleted-user")
      expect(user.email).to match(/\A\d+@deleted-user\z/)
    end

    it "should set the disabled_at timestamp" do
      expect(user.disabled_at).to_not be_nil
    end

    it "does not raise an error" do
      expect { user.disable! }.not_to raise_error
    end
  end

  context "scope tests" do
    let(:users) { create_list(:user, 5) }
    let(:ebooks) { create_list(:ebook, 2) }

    before do
      users.first(2).each_with_index do |user, idx|
        user.ebooks << ebooks[idx]
      end
    end

    it "should return the users that have ebooks" do
      expect(described_class.with_ebooks.size).to eq(2)
    end
  end
end
