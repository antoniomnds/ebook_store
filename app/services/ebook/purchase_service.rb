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
      emails_to_send = []

      ActiveRecord::Base.transaction do
        buyer = @user.buyer || @user.create_buyer
        buyer.ebooks << @ebook
        @ebook.update_attribute(:sales, @ebook.sales + 1)

        emails_to_send << -> { UserMailer.notify_purchase(@user, @ebook).deliver_later }
        emails_to_send << -> { UserMailer.notify_ebook_statistics(@user, @ebook).deliver_later }
      end

      emails_to_send.each(&:call)
    end
  end
end
