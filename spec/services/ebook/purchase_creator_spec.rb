# frozen_string_literal: true

require "rails_helper"
require "support/action_mailer_support"

RSpec.describe Ebook::PurchaseCreator do
  let(:ebook) { create(:ebook) }
  let(:user) { create(:user) }

  describe "#call" do
    context "when the ebook is archived" do
      it "raises an exception" do
        ebook.status = :archived
        expect { described_class.call(user, ebook) }.to raise_error(RuntimeError)
      end
    end

    context "when the ebook is not archived" do
      it "creates a purchase" do
        expect { described_class.call(user, ebook) }.to change(Purchase, :count).by(1)
      end

      it "changes the owner of the ebook" do
        expect { described_class.call(user, ebook) }.to change(ebook, :owner)
                                                          .from(ebook.owner).to(user)
      end

      it "increases the number of sales of the ebook" do
        expect { described_class.call(user, ebook) }.to change(ebook, :sales).by(1)
      end

      it "adds the ebook to the user's collection of ebooks" do
        described_class.call(user, ebook)
        expect(user.ebooks).to include(ebook).once
      end

      it "notifies the user on ebook's statistics" do
        expect_mailer_call(UserMailer, :notify_purchase, { user:, ebook: })
        expect_mailer_call(UserMailer, :notify_ebook_statistics, { user:, ebook: })

        described_class.call(user, ebook)
      end
    end
  end
end
