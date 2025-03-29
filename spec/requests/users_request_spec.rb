require 'rails_helper'

RSpec.describe "Users Request", type: :request do
  let(:user) { create(:user) }

  describe "Public access to users" do
    it "denies access to users#index" do
      get users_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end

    it "denies access to users#show" do
      get user_path(user)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end

    it "denies access to users#destroy" do
      user # eagerly create the user to not affect the next expectation

      expect { delete user_path(user) }.not_to change(User, :count)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end
  end

  describe "Authenticated access to users" do
    before do
      post sessions_path(email: user.email, password: user.password) # authenticate the user
      follow_redirect!
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

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_url)
        end

        it "cannot update another user" do
          original_email = another_user.email

          patch user_path(another_user), params: { user: attributes_for(:user) }

          another_user.reload

          expect(another_user.email).to eq(original_email)
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_url)
        end

        it "cannot destroy another user" do
          another_user # eagerly create another user to not affect the next expectation

          expect { delete user_path(another_user) }.not_to change(User, :count)

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_url)
        end
      end

      context "when managing himself" do
        it "allows access to users#edit" do
          get edit_user_path(user)

          expect(response).to have_http_status(:success)
        end

        context "with invalid information" do
          it "does not update the user" do
            original_email = user.email
            patch user_path(user), params: { user: attributes_for(:user, email: "") }

            user.reload

            expect(user.email).to eq(original_email)
            expect(response).to have_http_status(422)
          end
        end

        context "with valid information" do
          it "updates the user and redirects to the user's page" do
            original_email = user.email
            patch user_path(user), params: { user: attributes_for(:user) }

            user.reload

            expect(user.email).not_to eq(original_email)
            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to(user_path(user))
          end
        end

        context "when deleting the user" do
          it "soft deletes the user and redirects to the homepage" do
            user # eagerly create the user to not affect the next expectation

            expect { delete user_path(user) }.not_to change(User, :count) # soft delete

            user.reload

            expect(user).not_to be_enabled
            expect(user.disabled_at).not_to be_nil
            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to(root_url)
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

        patch user_path(another_user), params: { user: attributes_for(:user) }

        another_user.reload

        expect(another_user.email).not_to eq(original_email)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(user_path(another_user))
      end

      context "when deleting another user" do
        it "soft deletes the other user and redirects to the homepage" do
          another_user # eagerly create the user to not affect the next expectation

          expect { delete user_path(another_user) }.not_to change(User, :count) # soft delete

          another_user.reload

          expect(another_user).not_to be_enabled
          expect(another_user.disabled_at).not_to be_nil
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end
end
