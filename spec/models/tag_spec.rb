require 'rails_helper'
require 'support/shared_examples/model'
require 'support/shared_contexts/logging'

RSpec.describe Tag, type: :model do
  subject(:tag) { described_class.new(name: "Example Tag", description: "Lorem Ipsum") }

  include_context "logging"

  include_examples "model"

  it { is_expected.to have_attributes(name: "Example Tag", description: "Lorem Ipsum") }

  describe "#name" do
    it "is required" do
      tag.name = nil
      tag.valid?
      expect(tag.errors[:name].size).to eq(1)
    end
  end

  describe "#description" do
    it "is not required" do
      tag.description = nil
      tag.valid?
      expect(tag.errors[:description].size).to eq(0)
    end
  end
end
