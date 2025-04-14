require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome" do
    let(:user) { build(:user) }
    let(:mail) { UserMailer.with(user:).welcome }

    it "sends a welcome email to the user's email address" do
      expect(mail.to).to eq([ user.email ])
    end

    it "sends from the configured email account" do
      expect(mail.from).to eq([ "antoniomndsantos@gmail.com" ])
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq("Welcome to the Ebook Store!")
    end

    it "greets the user by its username" do
      expect(mail.body).to match(/Hi #{user.username}!/)
    end
  end

  describe "notify_purchase" do
    let(:user) { build(:user) }
    let(:ebook) { build(:ebook, owner: user) }
    let(:mail) { UserMailer.with(user:, ebook:).notify_purchase }

    it "sends a purchase notification email to the user's email address" do
      expect(mail.to).to eq([ user.email ])
    end

    it "sends from the configured email account" do
      expect(mail.from).to eq([ "antoniomndsantos@gmail.com" ])
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq("Thank you for buying '#{ebook.title}'")
    end

    it "greets the user by its username" do
      expect(mail.body).to match(/Hi #{user.username}!/)
    end

    it "thanks for buying the ebook" do
      expect(mail.body).to match(/Thank you for purchasing #{ebook.title}!/)
    end
  end

  describe "notify_ebook_statistics" do
    let(:user) { build(:user) }
    let(:ebook) { build(:ebook, owner: user) }
    let(:mail) { UserMailer.with(user:, ebook:).notify_ebook_statistics }

    it "sends a purchase notification email to the user's email address" do
      expect(mail.to).to eq([ user.email ])
    end

    it "sends from the configured email account" do
      expect(mail.from).to eq([ "antoniomndsantos@gmail.com" ])
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq("About your new Ebook '#{ebook.title}'")
    end

    it "greets the user by its username" do
      expect(mail.body).to match(/Hi #{user.username}!/)
    end

    it "sends some statistics on the ebook" do
      aggregate_failures do
        expect(mail.body).to match(/The book has been purchased #{ebook.sales} times./)
        expect(mail.body).to match(/The book has been viewed #{ebook.views} times in the store./)
        expect(mail.body).to match(/The preview of the book has been downloaded #{ebook.preview_downloads} times./)
      end
    end
  end
end
