require 'rails_helper'

RSpec.describe Tagging, type: :model do
  subject(:tagging) { build(:tagging) }

  describe "validation tests" do
    describe "#taggable" do
      it "is required" do
        tagging.taggable = nil

        tagging.valid?

        expect(tagging.errors[:taggable].first).to match(/must exist/)
      end
    end

    describe "#tag" do
      it "is required" do
        tagging.tag = nil

        tagging.valid?

        expect(tagging.errors[:tag].first).to match(/must exist/)
      end

      it "is unique per taggable" do
        another_tagging = create(:tagging)
        tagging.tag = another_tagging.tag
        tagging.taggable = another_tagging.taggable

        tagging.valid?

        expect(tagging.errors[:tag_id].first).to match(/Can't tag the same taggable twice with the same tag/)
      end
    end
  end
end
