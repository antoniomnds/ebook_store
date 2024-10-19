class UserMailer < ApplicationMailer
  default from: "antoniomndsantos@gmail.com"
  default to: "antonio.santos@runtime-revolution.com"

  def welcome
    @user = params[:user]

    mail(subject: "Welcome to the Ebook Store!")
  end

  def notify_purchase
    @user = params[:user]
    @ebook = params[:ebook]

    mail(subject: "Thank you for buying '#{@ebook.title}'")
  end

  def notify_ebook_statistics
    @user = params[:user]
    @ebook = params[:ebook]

    mail(subject: "About your new Ebook '#{@ebook.title}'")
  end
end
