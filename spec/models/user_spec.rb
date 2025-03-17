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
        it "is not valid" do
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

  describe "#authenticate" do
    context "with correct password" do
      it "returns the user" do
        expect(user.authenticate(user.password)).to be(user)
      end
    end

    context "with incorrect password" do
      it "returns false" do
        expect(user.authenticate(Faker::Internet.password)).to be(false)
      end
    end
  end

  it "can respond to the disable! method with no arguments" do
    expect(user).to respond_to(:disable!).and respond_to(:disable!).with(0).arguments
  end

  context "scope tests" do
    describe(".with_live_ebooks") do
      let(:users_with_live_ebooks) { create_pair(:user, :with_live_ebooks) }

      it "returns the users that have ebooks" do
        create(:ebook, :archived) # creates user that owns archived ebook
        create(:user) # doesn't own ebooks by default

        expect(described_class.with_live_ebooks).to match(users_with_live_ebooks)
      end
    end
  end

  describe "#disable!" do
    before do
      user.disable!
    end

    it "disables the user" do
      expect(user).not_to be_enabled
    end

    it "updates the username" do
      expect(user.username).to start_with("deleted-user-")
      expect(user.username).to match(/\Adeleted-user-\d+\z/)
    end

    it "updates the email" do
      expect(user.email).to end_with("@deleted-user")
      expect(user.email).to match(/\A\d+@deleted-user\z/)
    end

    it "sets the disabled_at timestamp" do
      expect(user.disabled_at).not_to be_nil
    end

    it "does not raise an error" do
      expect { user.disable! }.not_to raise_error
    end
  end

  describe "#resize_avatar" do
    it "pushes a job onto the job queue to resize the avatar" do
      expect(ResizeImageJob).to receive(:perform_later).with(described_class.name, nil, :avatar, 250, 250)

      user.send(:resize_avatar)
    end

    it "runs after database transaction" do
      allow(user.avatar).to receive(:attached?).and_return(true)

      expect(user).to receive(:resize_avatar).with(no_args)

      user.save!
    end
  end

  describe "#set_password_expiration" do
    it "postpones the password expiration date", :aggregate_failures do
      expect(user.password_expires_at).to be_nil
      # user is a new record so password_digest_changed? will return true
      user.run_callbacks(:validation)
      expect(user.password_expires_at).to be_within(1.seconds).of(Time.now + 6.months)
    end
  end
end
