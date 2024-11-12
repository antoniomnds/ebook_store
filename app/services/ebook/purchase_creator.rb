# frozen_string_literal: true

class Ebook
  class PurchaseCreator < ApplicationService
    attr_reader :user, :ebook

    def initialize(user, ebook)
      @user = user
      @ebook = ebook
    end

    def call
      raise "Ebook is archived." if ebook.status_archived?

      ActiveRecord::Base.transaction do
        buyer = user.buyer || user.create_buyer
        seller = ebook.user.seller || ebook.user.create_seller

        Purchase.create!(buyer: buyer, seller: seller, ebook: ebook, price: ebook.price)
        user.ebooks << ebook # change ebook ownership
        ebook.update_attribute(:sales, ebook.sales + 1)

        UserMailer.with(user: user, ebook: ebook).notify_purchase.deliver_later
        UserMailer.with(user: user, ebook: ebook).notify_ebook_statistics.deliver_later
      end
    end
  end
end
