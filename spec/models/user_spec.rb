require 'rails_helper'
require 'support/shared_contexts/logging'
require 'support/shared_examples/model'

RSpec.describe User, type: :model do
  subject do
    described_class.new(username: "test", email: "test@example.com", password: "password")
  end

  include_context "logging"

  include_examples "model"

  it { is_expected.to be_enabled }

  it { is_expected.not_to be_is_admin }

  it { is_expected.to be_active }

  it { is_expected.to have_attributes(username: "test", email: "test@example.com", password: "password", enabled: true, is_admin: false) }

  context "without a username" do
    subject(:user_without_username) do
      described_class.new(email: "test@example.com", password: "password")
    end

    it "is invalid" do
      expect(user_without_username).not_to be_valid
    end
  end

  context "without an email" do
    subject(:user_without_email) do
      described_class.new(username: "test", password: "password")
    end

    it "is invalid" do
      expect(user_without_email).not_to be_valid
    end
  end

  context "with an invalid email" do
    subject do
      described_class.new(username: "test", email: "invalid_email", password: "password")
    end

    it { is_expected.to be_invalid }

    context("when saved with a bang") do
      it "will raise an error" do
        expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context "without a password" do
    subject { described_class.new(username: "test", email: "test@example.com") }

    it { is_expected.not_to be_valid }
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
        expect(subject.authenticate("password")).to be(subject)
      end
    end

    context "with incorrect password" do
      it "should return false" do
        expect(subject.authenticate("incorrect")).to be(false)
      end
    end
  end

  it "can respond to the inactivate! method with no arguments" do
    expect(subject).to respond_to(:inactivate!).and respond_to(:inactivate!).with(0).arguments
  end

  describe "#inactivate! method" do
    before do
      subject.inactivate!
    end

    it "should inactivate the user" do
      expect(subject.active).to eq(false)
    end

    it "should update the username" do
      expect(subject.username).to start_with("deleted-user-")
      expect(subject.username).to satisfy("contain a tag ending with a timestamp") do |value|
        value.match(/^deleted-user-\d+$/)
      end
    end

    it "should update the email" do
      expect(subject.email).to end_with("@deleted-user")
      expect(subject.email).to satisfy("contain a tag beginning with a timestamp") do |value|
        value.match(/^\d+@deleted-user$/)
      end
    end

    it "should set the inactivated_at timestamp" do
      expect(subject.inactivated_at).to be_a(DateTime)
    end

    it "does not raise an error" do
      expect { subject.inactivate! }.not_to raise_error
    end
  end

  #  def inactivate!
  #    ActiveRecord::Base.transaction do
  #      update!(
  #        active: false,
  #        username: "deleted-user-#{ DateTime.now.to_i }",
  #        email: "#{ DateTime.now.to_i }@deleted-user",
  #        inactivated_at: DateTime.now
  #      )
  #      # noinspection RailsParamDefResolve
  #      ebooks.update_all(status: :archived, updated_at: DateTime.now)
  #    end
  #  end
end
