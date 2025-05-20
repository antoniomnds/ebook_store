require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#error_messages_for" do
    it "renders the template for error messages" do
      user = instance_double(User)
      allow(helper).to receive(:render).with("application/error_messages", object: user)

      helper.error_messages_for(user)

      expect(helper).to have_received(:render).with("application/error_messages", object: user)
    end
  end
end
