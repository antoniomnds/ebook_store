require 'rails_helper'

RSpec.describe "layouts/_flash_messages", type: :view do
  context "when flash has no entries" do
    it "is empty" do
      render

      expect(rendered).to be_empty
    end
  end

  context "when the flash has an entry" do
    it "has a div containing that entry" do
      error_message = "An error occurred!"
      flash.alert = error_message

      render

      expect(rendered).to have_css("div", text: error_message)
    end
  end
end
