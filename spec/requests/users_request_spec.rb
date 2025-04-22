require 'rails_helper'

RSpec.describe "Users Request", type: :request do
  let(:user) { create(:user) }

  describe "Public access to users" do
    it "denies access to users#index" do
      get users_path

      expect(response).to redirect_with_flash_to(new_session_url, :alert)
    end

    it "denies access to users#show" do
      get user_path(user)

      expect(response).to redirect_with_flash_to(new_session_url, :alert)
    end

    it "denies access to users#edit" do
      get edit_user_path(user)

      expect(response).to redirect_with_flash_to(new_session_url, :alert)
    end

    it "denies access to users#update" do
      patch user_path(user), params: { user: attributes_for(:user) }

      expect(response).to redirect_with_flash_to(new_session_url, :alert)
    end

    it "denies access to users#destroy" do
      user # eagerly create the user to not affect the next expectation

      expect { delete user_path(user) }.not_to change(User, :count)

      expect(response).to redirect_with_flash_to(new_session_url, :alert)
    end
  end

  describe "Authenticated access to users" do
    include ActionDispatch::TestProcess::FixtureFile

    let(:avatar) { file_fixture_upload("avatar.jpg", "image/jpg") } #

    before do
      sign_in_request_as user # authenticate the user
    end

    it "grants access to users#index" do
      get users_path

      expect(response).to have_http_status(:success)
    end

    it "grants access to users#show" do
      get user_path(user)

      expect(response).to have_http_status(:success)
    end

    context "when not an admin user" do
      context "when managing other user" do
        let(:another_user) { create(:user) }

        it "denies access to users#edit" do
          get edit_user_path(another_user)

          expect(response).to redirect_with_flash_to(root_url, :alert)
        end

        it "cannot update another user" do
          expect do
            patch user_path(another_user), params: { user: attributes_for(:user) }
            another_user.reload
          end.not_to change(another_user, :email)

          expect(response).to redirect_with_flash_to(root_url, :alert)
        end

        it "cannot destroy another user" do
          another_user # eagerly create another user to not affect the next expectation

          expect { delete user_path(another_user) }.not_to change(User, :count)

          expect(response).to redirect_with_flash_to(root_url, :alert)
        end
      end

      context "when managing himself" do
        it "allows access to users#edit" do
          get edit_user_path(user)

          expect(response).to have_http_status(:success)
        end

        context "with invalid information" do
          it "does not update the user" do
            expect do
              patch user_path(user), params: { user: attributes_for(:user, email: "") }
              user.reload
            end.not_to change(user, :email)

            expect(response).to have_http_status(422)
          end
        end

        context "with valid information" do
          it "updates the user and redirects to the user's page" do
            original_email = user.email
            user_attr = attributes_for(:user).merge(avatar:)

            expect do
              patch user_path(user), params: { user: user_attr }
              user.reload
            end.to change(user, :email).from(original_email).to(user_attr[:email])

            aggregate_failures do
              expect_uploaded_file(user, :avatar)
              expect(response).to redirect_with_flash_to(user_url(user), :notice)
            end
          end
        end

        context "when deleting the user" do
          it "soft deletes the user" do
            user # eagerly create the user to not affect the next expectation

            expect { delete user_path(user) }.not_to change(User, :count) # soft delete

            user.reload

            aggregate_failures do
              expect(user).not_to be_enabled
              expect(user.disabled_at).not_to be_nil
            end
          end

          it "redirects to the homepage" do
            delete user_path(user)

            expect(response).to redirect_with_flash_to(root_url, :notice)
          end

          it "logs the user out" do
            expect do
              delete user_path(user)
            end.to change { session.has_key?("current_user_id") }.from(true).to(false)
          end
        end

        context "when deleting an inconsistent user" do
          it "redirects back" do
            allow(User).to receive(:find).and_return(user) # return this user instead of a new object
            allow(user).to receive(:disable!).and_raise(ActiveRecord::RecordInvalid)

            # in the test env each request (get, post, delete, etc.) is isolated and independent
            # and Rails doesn't carry over the referer from one test request to the next
            delete user_path(user.id), headers: { "HTTP_REFERER" => users_url }

            expect(response).to redirect_with_flash_to(users_url, :alert)
          end
        end
      end
    end

    context "when an admin user" do
      let(:another_user) { create(:user) }

      before do
        user.update!(admin: true)
      end

      it "can access users#edit of another user" do
        get edit_user_path(another_user)

        expect(response).to have_http_status(:success)
      end

      it "updates other users" do
        original_email = another_user.email
        user_attr = attributes_for(:user).merge(avatar:)

        expect do
          patch user_path(another_user), params: { user: user_attr }
          another_user.reload
        end.to change(another_user, :email).from(original_email).to(user_attr[:email])

        aggregate_failures do
          expect_uploaded_file(another_user, :avatar)
          expect(response).to redirect_with_flash_to(user_url(another_user), :notice)
        end
      end

      context "when deleting another user" do
        it "soft deletes the other user and redirects to the homepage" do
          another_user # eagerly create the user to not affect the next expectation

          expect { delete user_path(another_user) }.not_to change(User, :count) # soft delete

          another_user.reload

          aggregate_failures do
            expect(another_user).not_to be_enabled
            expect(another_user.disabled_at).not_to be_nil
            expect(response).to redirect_with_flash_to(root_url, :notice)
          end
        end
      end

      context "when deleting a disabled user" do
        it "redirects back" do
          another_user.disable!

          expect do
            delete user_path(another_user), headers: { "HTTP_REFERER" => users_url }
          end.not_to change(User, :count) # soft delete

          expect(response).to redirect_with_flash_to(users_url, :alert)
        end
      end
    end
  end
end
