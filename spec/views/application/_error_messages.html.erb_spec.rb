require 'rails_helper'

RSpec.describe "application/_error_messages", type: :view do
  context "when the object has no errors" do
    it "is empty" do
      object = build(:user)
      object.valid?

      render locals: { object: }

      expect(rendered).to be_empty
    end
  end

  context "when the object has errors" do
    it "has a header indicating the number of errors" do
      object = User.new
      object.valid?
      expected_text = "#{pluralize(object.errors.count, "error")} prohibited this user from being saved:"

      render locals: { object: }

      expect(rendered.squish).to have_css("h2", text: expected_text)
    end

    it "has a list with the errors" do
      object = User.new
      object.valid?

      render locals: { object: }

      expect(rendered).to have_css("li", count: object.errors.count)
    end
  end
end
