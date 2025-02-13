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
          patch user_path(user: attributes_for(:user), id: another_user.id)

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

        context "with an invalid user" do
          it "does not update the user" do
            original_email = user.email
            patch user_path(user: attributes_for(:user, email: ""), id: user.id)

            user.reload
            expect(user.email).to eq(original_email)
            expect(response).to have_http_status(422)
          end
        end

        context "with an valid user" do
          it "updates the user and redirects to the user's page" do
            original_email = user.email
            patch user_path(user: attributes_for(:user), id: user.id)

            user.reload
            expect(user.email).not_to eq(original_email)
            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to(user_path(user))
          end
        end

        it "soft deletes the user and redirects to the homepage" do
          user # eagerly create the user to not affect the next expectation
          expect { delete user_path(user) }.to change(User, :count).by(0) # soft delete

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context "when an admin user" do
      let(:another_user) { create(:user) }
      before do
        user.update(admin: true)
      end

      it "can access users#edit of another user" do
        get edit_user_path(another_user)
        expect(response).to have_http_status(:success)
      end

      it "updates other users" do
        original_email = another_user.email
        patch user_path(user: attributes_for(:user), id: another_user.id)

        another_user.reload
        expect(another_user.email).not_to eq(original_email)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(user_path(another_user))
      end

      it "cannot destroy other users" do
        user # eagerly create the user to not affect the next expectation
        expect { delete user_path(user) }.to change(User, :count).by(0) # soft delete

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
