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

  describe "#ebooks" do
    it "can be associated with ebooks" do
      ebook = build(:ebook)

      tag.ebooks << ebook

      expect(tag.ebooks).to include(ebook)
    end

    it "removes the tagging when destroyed" do
      ebook = create(:ebook)

      tag.ebooks << ebook
      # tag is only in memory (build(:tag)), thus the tagging wasn't yet created
      tag.save!

      expect { tag.destroy }.to change(Tagging, :count).by(-1)
    end
  end
end
