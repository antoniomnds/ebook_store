require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { build(:tag) }

  describe "validation tests" do
    describe "#name" do
      it "is required" do
        tag.name = nil
        tag.valid?
        expect(tag.errors[:name].first).to match(/blank/)
      end

      it "is unique" do
        create(:tag, name: tag.name)
        tag.valid?
        expect(tag.errors[:name].first).to match(/already been taken/)
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
end
