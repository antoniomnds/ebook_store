require 'rails_helper'

RSpec.describe EbooksHelper, type: :helper do
  describe "#cover_image_tag" do
    context "when a cover image is not attached" do
      it "returns nil" do
        ebook = build_stubbed(:ebook)

        expect(helper.cover_image_tag(ebook)).to be_nil
      end
    end

    context "when Active Storage service is cloudinary" do
      it "returns an image tag with a remote source" do
        allow(Rails.configuration.active_storage).to receive(:service).and_return(:cloudinary)
        ebook = build_stubbed(:ebook)
        cover_image_key = "sample_key"
        cover_image_mock = double(:cover_image, attached?: true, key: cover_image_key)
        allow(ebook).to receive(:cover_image).and_return(cover_image_mock)

        result = helper.cover_image_tag(ebook)
        doc = Nokogiri::HTML.fragment(result || "")
        img = doc.at_css("img")

        aggregate_failures do
          expect(img).not_to be_nil
          expect(img["src"]).to match(%r{https://res\.cloudinary\.com/\w+/image/upload/.*/#{cover_image_key}(\?.*)?})
        end
      end
    end

    context "when Active Storage service is local" do
      it "returns an image tag with a thumbnail variant from a local source" do
        allow(Rails.configuration.active_storage).to receive(:service).and_return(:local)
        ebook = build_stubbed(:ebook)
        cover_image_url = asset_url(file_fixture("cover.jpg"))

        # create a simplified variant mock that can be converted to a URL
        variant_mock = double(:variant)
        # skip the polymorphic URL generation
        allow(helper).to receive(:polymorphic_url).and_return(cover_image_url)
        # set up the cover image mock, which is an "unverified" double since the variant method is only available through delegation at runtime
        cover_image_mock = double(:cover_image, attached?: true)
        allow(cover_image_mock).to receive(:variant).with(:thumb).and_return(variant_mock)
        allow(ebook).to receive(:cover_image).and_return(cover_image_mock)

        result = helper.cover_image_tag(ebook)
        doc = Nokogiri::HTML.fragment(result || "")
        img = doc.at_css("img")

        aggregate_failures do
          expect(img).not_to be_nil
          expect(img["src"]).to include(cover_image_url)
        end
      end
    end
  end

  describe "#ebook_status_tag" do
    it "returns different HTML for different status" do
      results = Ebook.statuses.map do |status, _|
        ebook = instance_double(Ebook, status:)
        helper.ebook_status_tag(ebook)
      end

      expect(results.uniq.count).to eq(Ebook.statuses.count)
    end

    context "when status is archived" do
      it "returns a span with 'Archived' text" do
        ebook = instance_double(Ebook, status: "archived")

        result = helper.ebook_status_tag(ebook)

        expect(result).to have_css("span", text: ebook.status.titleize)
      end
    end

    context "when status is draft" do
      it "returns a span with 'Draft' text" do
        ebook = instance_double(Ebook, status: "draft")

        result = helper.ebook_status_tag(ebook)

        expect(result).to have_css("span", text: ebook.status.titleize)
      end
    end

    context "when status is pending" do
      it "returns a span with 'Pending' text" do
        ebook = instance_double(Ebook, status: "pending")

        result = helper.ebook_status_tag(ebook)

        expect(result).to have_css("span", text: ebook.status.titleize)
      end
    end

    context "when status is live" do
      it "returns a span with 'Available' text" do
        ebook = instance_double(Ebook, status: "live")

        result = helper.ebook_status_tag(ebook)

        expect(result).to have_css("span", text: "Available")
      end
    end

    context "when status is unknown" do
      it "returns a span with the titleized status" do
        ebook = instance_double(Ebook, status: "other status")

        result = helper.ebook_status_tag(ebook)

        expect(result).to have_css("span", text: ebook.status.titleize)
      end
    end

    context "when status is nil" do
      it "returns a span with empty text" do
        ebook = instance_double(Ebook, status: nil)

        result = helper.ebook_status_tag(ebook)

        expect(result).to have_css("span", text: "")
      end
    end
  end

  describe "#purchase_button" do
    context "when the user is not logged in" do
      it "returns nil" do
        live_ebook = build_stubbed(:ebook, :live)

        expect(helper.purchase_button(live_ebook)).to be nil
      end
    end

    context "when the user is the owner of the ebook" do
      it "returns nil" do
        ebook_owner = build_stubbed(:user)
        live_ebook = build_stubbed(:ebook, :live, owner: ebook_owner)
        allow(helper).to receive(:current_user).and_return(ebook_owner) # log in user

        expect(helper.purchase_button(live_ebook)).to be nil
      end
    end

    context "when the ebook status is not live" do
      it "returns nil" do
        status = Ebook.statuses.keys.reject { |s| s == "live" }.sample
        ebook = build_stubbed(:ebook, status:, owner: build_stubbed(:user))
        user = instance_double(User, id: 2)
        allow(helper).to receive(:current_user).and_return(user) # log in user

        expect(helper.purchase_button(ebook)).to be nil
      end
    end

    context "when logged in, not the ebook owner and ebook status is live" do
      it "returns a button to purchase the ebook" do
        live_ebook = build_stubbed(:ebook, :live)
        allow(helper).to receive(:current_user).and_return(instance_double(User, id: 1)) # log in user

        result = helper.purchase_button(live_ebook)

        aggregate_failures do
          expect(result).to include("action=\"/ebooks/#{live_ebook.id}/purchase\"")
          expect(result).to have_button("Purchase", type: "submit")
        end
      end
    end
  end

  describe "#edit_ebook_button" do
    context "when the user is not the owner of the ebook" do
      it "returns nil" do
        user = instance_double(User)
        another_user = instance_double(User)
        ebook = instance_double(Ebook, owner: user)
        allow(helper).to receive(:current_user).and_return(another_user) # log in user

        expect(helper.edit_ebook_button(ebook)).to be_nil
      end
    end

    context "when the user is the owner of the ebook" do
      it "returns a link to edit the ebook" do
        user = build_stubbed(:user)
        ebook = build_stubbed(:ebook, owner: user)
        allow(helper).to receive(:current_user).and_return(user) # log in user

        result = helper.edit_ebook_button(ebook)

        expect(result).to have_link("Edit this ebook", href: edit_ebook_path(ebook))
      end
    end
  end

  describe "#delete_ebook_button" do
    context "when the user is not the owner of the ebook" do
      it "returns nil" do
        user = instance_double(User)
        another_user = instance_double(User)
        ebook = instance_double(Ebook, owner: user)
        allow(helper).to receive(:current_user).and_return(another_user) # log in user

        expect(helper.delete_ebook_button(ebook)).to be_nil
      end
    end

    context "when the user is the owner of the ebook" do
      it "returns a button to delete the ebook" do
        user = build_stubbed(:user)
        ebook = build_stubbed(:ebook, owner: user)
        allow(helper).to receive(:current_user).and_return(user) # log in user

        result = helper.delete_ebook_button(ebook)

        aggregate_failures do
          expect(result).to have_field(type: "hidden", name: "_method", with: "delete")
          expect(result).to have_button("Delete this ebook", type: "submit")
        end
      end
    end
  end

  describe "#ebook_summary_tag" do
    context "when there's no summary to present" do
      it "returns nil" do
        expect(helper.ebook_summary_tag(nil)).to be nil
      end
    end

    context "when there's a summary to present" do
      it "returns a div with the summary" do
        summary = "Lorem ipsum"

        result = helper.ebook_summary_tag(summary)

        expect(result).to have_css("div", id: "ebook_summary", text: summary)
      end
    end
  end
end
