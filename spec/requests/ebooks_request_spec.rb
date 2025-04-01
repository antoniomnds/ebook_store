require 'rails_helper'
require 'support/login_support'
require 'support/file_support'
require 'support/api_support'

RSpec.describe "Ebooks Request", type: :request do
  include ActionDispatch::TestProcess::FixtureFile

  describe "Public access to ebooks" do
    let(:ebook) { create(:ebook) }

    it "allows access to ebooks#index" do
      get ebooks_path

      expect(response).to have_http_status(:success)
    end

    it "allows access to ebooks#show" do
      stub_review_request(title: ebook.title)

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
    let(:cover_image) { file_fixture_upload("cover.jpg", "image/jpg") }
    let(:preview_file) { file_fixture_upload("sample.pdf", "application/pdf") }

    before do
      sign_in_request_as user
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
        expect do
          patch ebook_path(ebook), params: { ebook: attributes_for(:ebook) }
          ebook.reload
        end.not_to change(ebook, :title)

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
          expect do
            patch ebook_path(owned_ebook), params: { ebook: attributes_for(:ebook, title: "") }
            owned_ebook.reload
          end.not_to change(owned_ebook, :title)

          expect(response).to have_http_status(422)
        end
      end

      context "with a valid ebook" do
        it "updates the ebook and redirects to the ebook's page" do
          original_title = owned_ebook.title
          ebook_attr = attributes_for(:ebook).merge(cover_image:, preview_file:)

          expect do
            patch ebook_path(owned_ebook), params: { ebook: ebook_attr }
            owned_ebook.reload
          end.to change(owned_ebook, :title).from(original_title).to(ebook_attr[:title])

          aggregate_failures do
            expect_uploaded_file(owned_ebook, :cover_image)
            expect_uploaded_file(owned_ebook, :preview_file)
          end
          aggregate_failures do
            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to(ebook_url(owned_ebook))
          end
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
