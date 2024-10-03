require 'rails_helper'
require 'support/shared_examples/model'
require 'support/shared_contexts/logging'

RSpec.describe Tag, type: :model do
  subject(:tag) { build(:tag) }

  include_context "logging"

  include_examples "model"

  it { is_expected.to have_attributes(name: "Example Tag", description: "Lorem Ipsum") }

  describe "#name" do
    it "is required" do
      tag.name = nil
      tag.valid?
      expect(tag.errors[:name].first).to match(/blank/)
    end
  end

  describe "#description" do
    it "is not required" do
      tag.description = nil
      tag.valid?
      expect(tag.errors[:description]).to be_empty
    end
  end
end
