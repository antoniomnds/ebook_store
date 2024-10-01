class Ebook
  class PurchaseService
    class << self
      def purchase(user, ebook)
        new(user, ebook).purchase
      end
    end

    attr_reader :user, :ebook

    def initialize(user, ebook)
      @user = user
      @ebook = ebook
    end

    def purchase
      raise "Ebook is archived." if ebook.status_archived?

      ActiveRecord::Base.transaction do
        buyer = user.buyer || user.create_buyer
        seller = ebook.user.seller || ebook.user.create_seller

        Purchase.create!(buyer: buyer, seller: seller, ebook: ebook, price: ebook.price)
        user.ebooks << ebook # change ebook ownership
        ebook.update_attribute(:sales, ebook.sales + 1)

        UserMailer.notify_purchase(user, ebook).deliver_later
        UserMailer.notify_ebook_statistics(user, ebook).deliver_later
      end
    end
  end
end
