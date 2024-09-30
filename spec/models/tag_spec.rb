require 'rails_helper'
require 'support/shared_examples/model'
require 'support/shared_contexts/logging'

RSpec.describe Tag, type: :model do
  subject { described_class.new(name: "Example Tag", description: "Lorem Ipsum") }

  include_context "logging"

  include_examples "model"

  it { is_expected.to have_attributes(name: "Example Tag", description: "Lorem Ipsum") }

  context "without attributes" do
    subject(:tag_without_attributes) { Tag.new }

    it { is_expected.not_to be_valid }
  end

  context "without a name" do
    subject(:tag_without_name) { Tag.new(description: "Lorem Ipsum") }

    it { is_expected.not_to be_valid }
  end

  context "without a description" do
    subject { Tag.new(name: "Example Tag") }

    it { is_expected.to be_valid }
  end
end
