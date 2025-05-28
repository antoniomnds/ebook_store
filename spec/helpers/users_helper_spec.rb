require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe "#avatar_tag" do
    let(:user) { build(:user) }

    context "when no avatar is attached" do
      it "returns nil" do
        expect(helper.avatar_tag(user)).to be_nil
      end
    end

    context "when the avatar attachment is attached" do
      context "when Active Storage service is Cloudinary" do
        it "returns an image tag with a cloudinary URL" do
          allow(Rails.configuration.active_storage).to receive(:service).and_return(:cloudinary)
          # Configure Cloudinary with test values for CI
          Cloudinary.config_from_url("cloudinary://dummy_key:dummy_secret@dummy_cloud")
          # partially mock the attachment system
          avatar_key = "sample_key"
          # make an "unverified" double for avatar since the method key is only available through delegation at runtime
          mocked_avatar = double(:avatar, attached?: true, key: avatar_key)
          allow(user).to receive(:avatar).and_return(mocked_avatar)

          result = helper.avatar_tag(user)

          aggregate_failures do
            expect(result).to include("<img")
            expect(result).to include("src=\"https://res.cloudinary.com")
            expect(result).to include(avatar_key)
          end
        end
      end

      context "when Active Storage service is Local" do
        # the image_tag helper attempts to convert an ActiveStorage variant to a URL
        it "returns an image tag with a thumbnail variant" do
          allow(Rails.configuration.active_storage).to receive(:service).and_return(:local)
          avatar_url = asset_url(file_fixture("avatar.jpg"))
          # create a simplified variant mock that can be converted to a URL
          variant_mock = double(:variant)
          # skip the polymorphic URL generation
          allow(helper).to receive(:polymorphic_url).with(variant_mock).and_return(avatar_url)
          # set up the avatar mock, which is an "unverified" double since the variant method is only available through delegation at runtime
          avatar_mock = double(:avatar, attached?: true)
          allow(avatar_mock).to receive(:variant).with(hash_including(:resize_to_limit)).and_return(variant_mock)
          allow(user).to receive(:avatar).and_return(avatar_mock)

          result = helper.avatar_tag(user)

          aggregate_failures do
            expect(result).to include("<img")
            expect(result).to include(avatar_url)
          end
        end
      end
    end
  end

  describe "#admin_tag" do
    context "when not an admin user" do
      it "returns nil" do
        user = build_stubbed(:user)

        expect(helper.admin_tag(user)).to be_nil
      end
    end

    context "when an admin user" do
      it "returns a span tag containing the Admin wording" do
        admin_user = build_stubbed(:user, admin: true)

        result = helper.admin_tag(admin_user)

        aggregate_failures do
          expect(result).to include("<span")
          expect(result).to include("Admin")
        end
      end
    end
  end

  describe "#password_challenge_tag" do
    let(:form_mock) do
      instance_double(ActionView::Helpers::FormBuilder).tap do |f|
        allow(f).to receive(:label)
                      .with(:password_challenge, "Current password", any_args)
                      .and_return("<label for=\"user_password_challenge\">Current password</label>".html_safe)
        allow(f).to receive(:password_field)
                      .with(:password_challenge, any_args)
                      .and_return("<input type=\"password\">".html_safe)
      end
    end

    # admin user is not required to fill the current password when editing a user
    context "when an admin user" do
      it "returns nil" do
        admin_user = build_stubbed(:user, :admin)
        allow(helper).to receive(:current_user).and_return(admin_user)

        expect(helper.password_challenge_tag(form_mock)).to be nil
      end
    end

    context "when a non-admin user" do
      it "returns a div with the password challenge label and input" do
        user = build_stubbed(:user)
        allow(helper).to receive(:current_user).and_return(user)

        result = helper.password_challenge_tag(form_mock)

        aggregate_failures do
          expect(result).to include("<label")
          expect(result).to include("for=\"user_password_challenge\"")
          expect(result).to include(">Current password</label>")
          expect(result).to include("<input")
          expect(result).to include("type=\"password\"")
        end
      end
    end
  end

  describe "#user_enabled_tag" do
    let(:form_mock) do
      instance_double(ActionView::Helpers::FormBuilder).tap do |f|
        allow(f).to receive(:label)
                      .with(:enabled, any_args)
                      .and_return("<label for=\"user_enabled\">Enabled</label>".html_safe)
        allow(f).to receive(:check_box)
                      .with(:enabled, any_args)
                      .and_return("<input type=\"checkbox\">".html_safe)
      end
    end

    context "when an admin_user" do
      it "returns a checkbox and label for the enabled field" do
        admin_user = build_stubbed(:user, :admin)
        allow(helper).to receive(:current_user).and_return(admin_user) # log in user

        result = helper.user_enabled_tag(form_mock)

        aggregate_failures do
          expect(result).to include("<label")
          expect(result).to include("for=\"user_enabled\"")
          expect(result).to include(">Enabled</label>")
          expect(result).to include("<input")
          expect(result).to include("type=\"checkbox\"")
        end
      end
    end

    context "when not an admin user" do
      it "returns nil" do
        user = build_stubbed(:user)
        allow(helper).to receive(:current_user).and_return(user) # log in user

        expect(helper.user_enabled_tag(form_mock)).to be_nil
      end
    end
  end

  describe "#delete_user_button" do
    context "when the user is disabled" do
      it "is disabled" do
        user = build_stubbed(:user, enabled: false)

        expect(helper.delete_user_button(user)).to include("disabled=\"disabled\"")
      end
    end

    context "when another user and current user is not admin" do
      it "is disabled" do
        user = build_stubbed(:user)
        another_user = build_stubbed(:user)
        allow(helper).to receive(:current_user).and_return(user) # log in user

        expect(helper.delete_user_button(another_user)).to include("disabled=\"disabled\"")
      end
    end

    context "when another user and current user is admin" do
      it "is not disabled" do
        user = build_stubbed(:user, :admin)
        another_user = build_stubbed(:user)
        allow(helper).to receive(:current_user).and_return(user) # log in user

        expect(helper.delete_user_button(another_user)).not_to include("disabled=\"disabled\"")
      end
    end

    context "when user is current user" do
      it "is not disabled" do
        user = build_stubbed(:user, :admin)
        allow(helper).to receive(:current_user).and_return(user) # log in user

        expect(helper.delete_user_button(user)).not_to include("disabled=\"disabled\"")
      end
    end
  end
end
