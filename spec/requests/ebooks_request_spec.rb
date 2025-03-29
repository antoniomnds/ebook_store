require 'rails_helper'

RSpec.describe "Ebooks Request", type: :request do
  describe "Public access to ebooks" do
    let(:ebook) { create(:ebook) }

    it "allows access to ebooks#index" do
      get ebooks_path

      expect(response).to have_http_status(:success)
    end

    it "allows access to ebooks#show" do
      mocked_review = { results: [ { summary: Faker::Lorem.sentence } ] }.to_json
      allow(Ebook::ReviewFetcher).to receive(:call).with(ebook).and_return(mocked_review)

      get ebook_path(ebook)

      expect(response).to have_http_status(:success)
    end

    it "allows access to ebooks#increment_views" do
      expect do
        patch increment_views_ebook_path(ebook)
        ebook.reload
      end.to change(ebook, :views).by(1)

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it "denies access to ebooks#new" do
      get new_ebook_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end

    it "denies access to ebooks#create" do
      expect do
        post ebooks_path, params: { ebook: attributes_for(:ebook) }
      end.not_to change(Ebook, :count)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end

    it "denies access to ebooks#edit" do
      get edit_ebook_path(ebook)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end

    it "denies access to ebooks#destroy" do
      ebook # eagerly create the ebook to not affect the next expectation

      expect { delete ebook_path(ebook) }.not_to change(Ebook, :count)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end

    it "denies access to ebooks#purchase" do
      expect { post purchase_ebook_path(ebook) }.not_to change(Purchase, :count)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end

    it "denies access to ebooks#my_ebooks" do
      get my_ebooks_ebooks_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_url)
    end
  end

  describe "Authenticated access to ebooks" do
    let(:user) { create(:user) }
    let(:ebook) { create(:ebook) }

    before do
      post sessions_path(email: user.email, password: user.password) # authenticate the user
      follow_redirect!
    end

    it "grants access to ebooks#new" do
      get new_ebook_path

      expect(response).to have_http_status(:success)
    end

    describe "ebooks#create" do
      context "with an invalid ebook" do
        it "does not create an ebook" do
          expect do
            post ebooks_path, params: { ebook: attributes_for(:ebook) } # no associated user
          end.not_to change(Ebook, :count)

          expect(response).to have_http_status(422)
        end
      end

      context "with a valid ebook" do
        it "creates an ebook and redirects to the ebook's page" do
          expect do
            post ebooks_path, params: { ebook: attributes_for(:ebook).merge(user_id: user.id) }
          end.to change(Ebook, :count).by(1)

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(ebook_url(Ebook.last))
        end
      end
    end

    it "creates a purchase and redirects to the ebook page" do
      expect { post purchase_ebook_path(ebook) }.to change(Purchase, :count).by(1)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(ebook_url(ebook))
    end

    it "grants access to ebooks#my_ebooks" do
      get my_ebooks_ebooks_path

      expect(response).to have_http_status(:success)
    end

    context "when not the ebook owner" do
      it "denies access to ebooks#edit" do
        get edit_ebook_path(ebook)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(ebooks_url)
      end

      it "denies access to ebooks#update" do
        original_title = ebook.title

        patch ebook_path(ebook), params: { ebook: attributes_for(:ebook) }

        ebook.reload

        expect(ebook.title).to eq(original_title)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(ebooks_url)
      end

      it "denies access to ebooks#destroy" do
        ebook # eagerly create the ebook to not affect the next expectation

        expect { delete ebook_path(ebook) }.not_to change(Ebook, :count)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(ebooks_url)
      end
    end

    context "when the ebook owner" do
      let!(:owned_ebook) { create(:ebook, owner: user) }

      it "allows access to ebooks#edit" do
        get edit_ebook_path(owned_ebook)

        expect(response).to have_http_status(:success)
      end

      context "with an invalid ebook" do
        it "does not update the ebook" do
          original_title = owned_ebook.title

          patch ebook_path(owned_ebook), params: { ebook: attributes_for(:ebook, title: "") }

          owned_ebook.reload

          expect(owned_ebook.title).to eq(original_title)
          expect(response).to have_http_status(422)
        end
      end

      context "with a valid ebook" do
        it "updates the ebook and redirects to the ebook's page" do
          original_title = owned_ebook.title

          patch ebook_path(owned_ebook), params: { ebook: attributes_for(:ebook) }

          owned_ebook.reload

          expect(owned_ebook.title).not_to eq(original_title)
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(ebook_url(owned_ebook))
        end
      end

      it "deletes the ebook and redirects to the ebook listing" do
        expect { delete ebook_path(owned_ebook) }.to change(Ebook, :count).by(-1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(ebooks_url)
      end
    end
  end
end
