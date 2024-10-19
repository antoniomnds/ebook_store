class UserMailerPreview < ActionMailer::Preview
  def welcome
    UserMailer.with(user: User.first).welcome
  end

  def notify_purchase
    UserMailer.with(user: User.first, ebook: Ebook.first).notify_purchase
  end

  def notify_ebook_statistics
    UserMailer.with(user: User.first, ebook: Ebook.first).notify_ebook_statistics
  end
end
