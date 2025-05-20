class UserMailer < ApplicationMailer
  default from: "antoniomndsantos@gmail.com"

  def welcome
    @user = params[:user]

    mail(subject: "Welcome to the Ebook Store!", to: @user.email)
  end

  def notify_purchase
    @user = params[:user]
    @ebook = params[:ebook]
    @discount = 10

    mail(subject: "Thank you for buying '#{@ebook.title}'", to: @user.email)
  end

  def notify_ebook_statistics
    @user = params[:user]
    @ebook = params[:ebook]

    mail(subject: "About your new Ebook '#{@ebook.title}'", to: @user.email)
  end
end
