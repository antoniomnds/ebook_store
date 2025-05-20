require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome" do
    let(:user) { instance_double(User, email: "jonh_doe@example.com", username: "john_doe") }
    let(:mail) { described_class.with(user:).welcome }

    it "sends a welcome email to the user's email address" do
      expect(mail.to).to match_array([ user.email ])
    end

    it "sends from the configured email account" do
      expect(mail.from).to eq([ described_class.default_params[:from] ])
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq("Welcome to the Ebook Store!")
    end

    it "greets the user by its username" do
      expect(mail.body).to match(/Hi #{user.username}!/)
    end
  end

  describe "notify_purchase" do
    let(:user) { instance_double(User, email: "jonh_doe@example.com", username: "john_doe") }
    let(:ebook) { build_stubbed(:ebook) }
    let(:mail) { described_class.with(user:, ebook:).notify_purchase }

    it "sends a purchase notification email to the user's email address" do
      expect(mail.to).to eq([ user.email ])
    end

    it "sends from the configured email account" do
      expect(mail.from).to match_array([ described_class.default_params[:from] ])
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq("Thank you for buying '#{ebook.title}'")
    end

    it "greets the user by its username" do
      content = Nokogiri::HTML(mail.body.encoded).content

      expect(content).to include("Hi #{user.username}!")
    end

    it "thanks for buying the ebook" do
      content = Nokogiri::HTML(mail.body.encoded).content

      expect(content).to include("Thank you for purchasing \"#{ebook.title}\"!")
    end

    it "includes information on the discount applied" do
      discount = 10
      content = Nokogiri::HTML(mail.body.encoded).content.squish # squish removes extra whitespaces

      expected_text = %(
        You have gotten #{discount}% off the original price of #{ebook.price}€,
        which corresponds to a discount of #{ebook.discount_value(discount)}€!
      ).squish

      expect(content).to include(expected_text)
    end
  end

  describe "notify_ebook_statistics" do
    let(:user) { instance_double(User, email: "jonh_doe@example.com", username: "john_doe") }
    let(:ebook) { build_stubbed(:ebook) }
    let(:mail) { described_class.with(user:, ebook:).notify_ebook_statistics }

    it "sends a purchase notification email to the user's email address" do
      expect(mail.to).to eq([ user.email ])
    end

    it "sends from the configured email account" do
      expect(mail.from).to eq([ described_class.default_params[:from] ])
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq("About your new Ebook '#{ebook.title}'")
    end

    it "greets the user by its username" do
      content = Nokogiri::HTML(mail.body.encoded).content

      expect(content).to include("Hi #{user.username}!")
    end

    it "sends some statistics on the ebook" do
      content = Nokogiri::HTML(mail.body.encoded).content

      aggregate_failures do
        expect(content).to include("The book has been purchased #{ebook.sales} times.")
        expect(content).to include("The book has been viewed #{ebook.views} times in the store.")
        expect(content).to include("The preview of the book has been downloaded #{ebook.preview_downloads} times.")
      end
    end
  end
end
