require 'rails_helper'

RSpec.describe AuthenticationHelper, type: :helper do
  describe "#current_user" do
    it "returns the user from the session" do
      user = instance_double(User, id: 1)
      session[:current_user_id] = user.id

      # controller method is not accessible here for stubbing
      helper.define_singleton_method(:load_current_user) { user }

      expect(helper.current_user).to be(user)
    end
  end

  describe "#logged_in?" do
    context "when the user is logged in" do
      it "returns true" do
        user = instance_double(User)
        allow(helper).to receive(:current_user).and_return(user)

        expect(helper.logged_in?).to be(true)
        expect(helper).to have_received(:current_user).once
      end
    end

    context "when the user is not logged in" do
      it "returns false" do
        allow(helper).to receive(:current_user) # returns nil

        expect(helper.logged_in?).to be(false)
        expect(helper).to have_received(:current_user).once
      end
    end
  end
end
