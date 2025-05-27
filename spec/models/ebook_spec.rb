require 'rails_helper'

RSpec.describe Ebook, type: :model do
  subject(:ebook) { build(:ebook) }

  it "has zero sales by default" do
    expect(ebook.sales).to be_zero
  end

  it "has zero views by default" do
    expect(ebook.views).to be_zero
  end

  it "has zero preview downloads by default" do
    expect(ebook.preview_downloads).to be_zero
  end

  context "validation tests" do
    describe "#title" do
      it "is required" do
        ebook.title = nil
        ebook.valid?
        expect(ebook.errors[:title].first).to match(/blank/)
        expect(ebook.errors[:title].last).to match(/too short \(minimum is 4 characters\)/)
      end

      context "with a title less than four characters" do
        it "is be invalid" do
          ebook.title = "A" * 3
          ebook.valid?
          expect(ebook.errors[:title].first).to match(/too short \(minimum is 4 characters\)/)
        end
      end
    end

    describe "#status" do
      it "is required" do
        ebook.status = nil
        ebook.valid?
        expect(ebook.errors[:status].first).to match(/blank/)
      end

      it "belongs to a predefined set of values" do
        expect(ebook.status).to satisfy("be one of #{ Ebook.statuses.keys }") do |status|
          Ebook.statuses.keys.include?(status)
        end
      end
    end

    describe "#price" do
      it "is required" do
        ebook.price = nil
        ebook.valid?
        expect(ebook.errors[:price].first).to match(/blank/)
        expect(ebook.errors[:price].last).to match(/not a number/)
      end

      it "is not negative" do
        ebook.price = -1.to_d # field of type BigDecimal
        ebook.valid?
        expect(ebook.errors[:price].first).to match(/greater than or equal to 0.0/)
      end
    end

    describe "#authors" do
      it "is required" do
        ebook.authors = nil
        ebook.valid?
        expect(ebook.errors[:authors].first).to match(/blank/)
      end
    end

    describe "#genre" do
      it "is required" do
        ebook.genre = nil
        ebook.valid?
        expect(ebook.errors[:genre].first).to match(/blank/)
      end
    end

    describe "#publisher" do
      it "is required" do
        ebook.publisher = nil
        ebook.valid?
        expect(ebook.errors[:publisher].first).to match(/blank/)
      end
    end

    describe "#publication date" do
      it "is required" do
        ebook.publication_date = nil
        ebook.valid?
        expect(ebook.errors[:publication_date].first).to match(/blank/)
      end

      it "is not in the future" do
        ebook.publication_date = Date.tomorrow.end_of_day
        ebook.valid?
        expect(ebook.errors[:publication_date]).to contain_exactly "can't be in the future"
      end
    end

    describe "#pages" do
      it "is required" do
        ebook.pages = nil
        ebook.valid?
        expect(ebook.errors[:pages].first).to match(/blank/)
      end
    end

    describe "#ISBN" do
      it "is required" do
        ebook.isbn = nil
        ebook.valid?
        expect(ebook.errors[:isbn].first).to match(/blank/)
        expect(ebook.errors[:isbn].last).to match(/not a valid format/)
      end

      it "has a defined format" do
        expect(ebook.isbn).to match(/\A978-\d{10}\z/)
      end

      it "is unique" do
        create(:ebook, isbn: ebook.isbn)
        ebook.valid?
        expect(ebook.errors[:isbn].first).to match(/already been taken/)
      end
    end

    describe "#owner" do
      it "is required" do
        ebook.owner = nil
        ebook.valid?
        expect(ebook.errors[:owner].first).to match(/must exist/)
      end
    end
  end

  describe "#cover_image" do
    it "stores an uploaded cover image" do
      ebook.cover_image.attach(file_fixture("cover.jpg"))

      expect(ebook.cover_image).to be_attached
    end
  end

  describe "#preview_file" do
    it "stores an uploaded preview file" do
      ebook.preview_file.attach(file_fixture("sample.pdf"))

      expect(ebook.preview_file).to be_attached
    end
  end

  describe "#tags" do
    it "can be tagged" do
      tag = build(:tag)

      ebook.tags << tag

      expect(ebook.tags).to include(tag)
    end

    it "deletes taggings when destroyed" do
      tag = create(:tag)

      ebook.tags << tag
      # ebook is only in memory (build(:ebook)), thus the tagging wasn't yet created
      ebook.save!

      expect { ebook.destroy }.to change(Tagging, :count).by(-1)
    end
  end

  context "scope tests" do
    describe ".live" do
      it "returns the ebooks with status live" do
        live_ebooks = create_pair(:ebook, :live)
        create(:ebook, :archived)

        expect(described_class.live).to match_array(live_ebooks)
      end
    end

    describe ".filter" do
      it "returns the ebooks with the given tag(s)" do
        tagged_ebook = create(:ebook, :with_tags)
        create_pair(:ebook, :with_tags)

        filtered_ebooks = described_class.filter(tags: tagged_ebook.tag_ids)

        expect(filtered_ebooks).to contain_exactly(tagged_ebook)
      end

      it "returns the ebooks owned by the given users" do
        ebook = create(:ebook)
        create(:ebook) # another_ebook

        filtered_ebooks = described_class.filter(users: [ ebook.user_id ])

        expect(filtered_ebooks).to contain_exactly(ebook)
      end
    end
  end

  describe "#discount_value" do
    context "with a valid discount value" do
      it "returns the correct discount value" do
        discount = 10
        net_price = (ebook.price * (discount.fdiv(100))).round(2)
        expect(ebook.discount_value(discount)).to eq(net_price)
      end
    end

    context "with a negative discount value" do
      it "returns zero" do
        expect(ebook.discount_value(-1)).to be_zero
      end
    end

    context "with a discount above 100" do
      it "returns the price" do
        expect(ebook.discount_value(110)).to eq(ebook.price)
      end
    end
  end
end
