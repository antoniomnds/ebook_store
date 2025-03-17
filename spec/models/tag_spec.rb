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

  describe "scope tests" do
    describe ".with_live_ebooks" do
      it "returns tags assigned to ebooks that have status live" do
        live_tagged_ebook = create(:ebook, :live, :with_tags)
        create(:ebook, :archived, :with_tags) # archived tagged ebook
        create(:tag)

        expect(described_class.with_live_ebooks).to match(live_tagged_ebook.tags)
      end
    end

    describe ".with_ebooks_for_user" do
      it "returns tags assigned to ebooks owned by the given user" do
        user = create(:user)
        user_tagged_ebook = create(:ebook, :with_tags, owner: user)
        create(:ebook, :with_tags) # another user's tagged ebook
        create(:tag)

        expect(described_class.with_ebooks_for_user(user)).to match(user_tagged_ebook.tags)
      end
    end
  end
end
