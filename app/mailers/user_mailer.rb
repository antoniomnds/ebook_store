class UserMailer < ApplicationMailer
  default from: "antoniomndsantos@gmail.com"
  default to: "antonio.santos@runtime-revolution.com"

  def notify_purchase(user, ebook)
    @user = user
    @ebook = ebook
    @purchase_fee = (0.1 * @ebook.price).round(2)

    mail(subject: "Thank you for buying '#{@ebook.title}'")
  end

  def notify_ebook_statistics(user, ebook)
    @user = user
    @ebook = ebook

    mail(subject: "About your new Ebook '#{@ebook.title}'")
  end
end
