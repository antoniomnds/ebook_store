class Ebook
  class PurchaseService
    class << self
      def purchase(user, ebook)
        new(user, ebook).purchase
      end
    end
    def initialize(user, ebook)
      @user = user
      @ebook = ebook
    end

    def purchase
      ActiveRecord::Base.transaction do
        buyer = @user.buyer || @user.create_buyer
        buyer.ebooks << @ebook
        @ebook.update_attribute(:sales, @ebook.sales + 1)

        UserMailer.notify_purchase(@user, @ebook).deliver_later
        UserMailer.notify_ebook_statistics(@user, @ebook).deliver_later
      end
    end
  end
end
