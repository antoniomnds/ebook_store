require 'rails_helper'

RSpec.describe "Ebooks management", type: :system do
  def stub_ebook_review_request(ebook)
    stub_review_request(title: ebook.title)
  end

  def visit_ebooks_page
    visit root_path
    click_link "View Ebooks"
  end

  def visit_ebook_page(ebook)
    stub_ebook_review_request(ebook)

    visit_ebooks_page

    within "#ebook_#{ebook.id}" do
      click_link "Show"
    end
  end

  context "public access to ebooks" do
    context "when there are ebooks available" do
      let!(:ebooks) { create_list(:ebook, 20, :live, :with_tags) }
      let(:ebook) { ebooks.first }

      it "enables accessing ebooks from the homepage" do
        visit_ebooks_page

        expect_ebooks_page
      end

      def expect_ebooks_page
        expect(page).to have_current_path(ebooks_path)
        expect(page).to have_table(id: "ebooks")
      end

      it "enables accessing an ebook from the ebook listing" do
        visit_ebook_page(ebook)

        expect_ebook_page
      end

      def expect_ebook_page
        expect(page).to have_current_path(ebook_path(ebook))
        expect(page).to have_content(ebook.title)
      end

      it "enables finding an ebook by filtering by tag and owner" do
        excluded_ebook = ebooks.select { |e| e.owner != ebook.owner && (e.tags & ebook.tags).empty? }.first
        visit_ebooks_page

        filter_ebooks

        expect_filtered_ebooks(included_ebook: ebook, excluded_ebook:)
      end

      def filter_ebooks
        page.select ebook.tags.first.name, from: "tags" # select tag
        page.select ebook.owner.username, from: "users" # select user

        click_button "Filter"
      end

      def expect_filtered_ebooks(included_ebook:, excluded_ebook:)
        expect(page).to have_content(included_ebook.title)
        expect(page).to have_no_content(excluded_ebook.title)
      end

      context "when visiting an ebook" do
        before do
          visit_ebook_page(ebook)
        end

        it "enables the ebook's view counter to be incremented", js: true do
          initial_views, updated_views = increment_ebook_view_counter

          expect_incremented_view_counter(initial_views, updated_views)
        end

        def increment_ebook_view_counter
          initial_views = find("p", text: "Views").text.split.last.to_i

          visit current_path # refresh to trigger a view increment

          updated_views = find("p", text: "Views").text.split.last.to_i

          [ initial_views, updated_views ]
        end

        def expect_incremented_view_counter(initial_views, updated_views)
          expect(updated_views).to eq(initial_views + 1)
        end

        it "enables the ebook's summary to be fetched from NYT" do
          summary_content = mocked_review.dig(:results, 0, :summary)

          expect_ebook_summary(ebook, summary_content)
        end

        def expect_ebook_summary(ebook, summary)
          within "#ebook_#{ebook.id}" do
            expect(page).to have_css("div", id: "ebook_summary", text: summary)
          end
        end
      end
    end

    context "when there are no ebooks available" do
      it "shows an appropriate message together with a link to add one" do
        visit_ebooks_page

        expect_no_ebooks_available
      end

      def expect_no_ebooks_available
        expect(page).to have_css("div", class: "alert alert-info", text: "There are no ebooks available.")
        expect(page).to have_link("Add one", href: new_ebook_path)
      end
    end
  end

  context "authorized access to ebooks" do
    let(:user) { create(:user) }
    let(:ebook) { create(:ebook, :live, owner: user) }

    before do
      sign_in_as(user)
    end

    def fill_ebook_form(ebook_attr:, tag_name:)
      fill_in "Title", with: ebook_attr[:title]
      page.select ebook_attr[:status], from: "Status"
      fill_in "Price", with: ebook_attr[:price]
      fill_in "Authors", with: ebook_attr[:authors]
      fill_in "Genre", with: ebook_attr[:genre]
      fill_in "Publisher", with: ebook_attr[:publisher]
      fill_in "Publication date", with: ebook_attr[:publication_date].strftime("%Y-%m-%d")
      fill_in "Pages", with: ebook_attr[:pages]
      fill_in "Isbn", with: ebook_attr[:isbn]
      fill_in "Sales", with: ebook_attr[:sales]
      fill_in "Views", with: ebook_attr[:views]
      page.select tag_name, from: "Tags"
      fill_in "Preview downloads", with: ebook_attr[:preview_downloads]
      attach_file "Preview file", Rails.root.join("spec", "fixtures", "files", "sample.pdf")
      attach_file "Cover image", Rails.root.join("spec", "fixtures", "files", "cover.jpg")
    end

    it "enables access to the new ebook page" do
      visit_new_ebook_page

      expect_new_ebook_page
    end

    def visit_new_ebook_page
      visit_ebooks_page

      click_link "Add one"
    end

    def expect_new_ebook_page
      expect(page).to have_current_path(new_ebook_path)
      expect(page).to have_content("New ebook")
    end

    it "adds an ebook" do
      tag = create(:tag)
      ebook_attr = attributes_for(:ebook)
      # user gets redirected to the ebook page after submitting the form
      stub_ebook_review_request(instance_double("Ebook", title: ebook_attr[:title]))

      visit_new_ebook_page

      expect_ebook_created do
        create_ebook(ebook_attr, tag.name)
      end
    end

    def create_ebook(ebook_attr, tag_name)
      fill_ebook_form(ebook_attr:, tag_name:)
      click_button "Create Ebook"
    end

    def expect_ebook_created(&block)
      expect {
        yield # block is not optional

        expect(page).to have_current_path(/ebooks\/\d+/) # ensure the page updates before checking the database
      }.to change(Ebook, :count).by(1)
      expect(page).to have_content("Ebook was successfully created.")
    end

    it "enables access to the edit ebook page" do
      visit_edit_ebook_page(ebook)

      expect_edit_ebook_page(ebook)
    end

    def visit_edit_ebook_page(ebook)
      visit_ebook_page(ebook)

      click_link "Edit this ebook"
    end

    def expect_edit_ebook_page(ebook)
      expect(page).to have_current_path(edit_ebook_path(ebook))
      expect(page).to have_content("Editing ebook")
    end

    it "edits an ebook" do
      tag = create(:tag)
      ebook_attr = attributes_for(:ebook)

      # user gets redirected to the ebook page after submitting the form
      stub_ebook_review_request(instance_double("Ebook", title: ebook_attr[:title]))

      visit edit_ebook_path(ebook)

      update_ebook(ebook_attr, tag.name)

      expect_ebook_updated(ebook)
    end

    def update_ebook(ebook_attr, tag_name)
      fill_ebook_form(ebook_attr:, tag_name:)

      click_button "Update Ebook"
    end

    def expect_ebook_updated(ebook)
      expect(page).to have_current_path(ebook_path(ebook))
      expect(page).to have_content("Ebook was successfully updated")
    end

    it "removes an ebook", js: true do
      visit_ebook_page(ebook)

      expect_deleted_ebook do
        delete_ebook
      end
    end

    def delete_ebook
      accept_confirm "Are you sure you want to delete this ebook?" do
        click_button "Delete this ebook" # action that will trigger the system modal
      end
    end

    def expect_deleted_ebook(&block)
      expect {
        yield # block is not optional

        expect(page).to have_current_path(ebooks_path) # ensure the page updates before checking the database
      }.to change(Ebook, :count).by(-1)
      expect(page).to have_content("Ebook was successfully destroyed.")
      expect(page).not_to have_css("tr", id: "ebook_#{ebook.id}")
    end

    it "cannot remove an ebook already bought", js: true do
      create(:purchase, ebook:)
      visit_ebook_page(ebook)

      delete_ebook

      expect_ebook_not_deleted
    end

    def expect_ebook_not_deleted
      expect(page).to have_current_path(ebook_path(ebook))
      expect(page).to have_content("Ebook already bought and cannot be destroyed.")
    end

    it "buys an ebook", js: true do
      ebook = create(:ebook, :live)
      stub_ebook_review_request(ebook)

      visit_ebooks_page

      expect_ebook_bought ebook do
        buy_ebook(ebook)
      end
    end

    def buy_ebook(ebook)
      within "#ebook_#{ebook.id}" do
        accept_confirm "Are you sure you want to purchase this ebook?" do
          click_button "Purchase" # action that will trigger the system modal
        end
      end
    end

    def expect_ebook_bought(ebook, &block)
      expect {
        yield # block is not optional

        expect(page).to have_content("Ebook was successfully purchased.") # waits for the page to change
      }.to change(Purchase, :count).by(1)

      expect(page).to have_current_path(ebook_path(ebook))
      expect(page).to have_content(ebook.title)
    end
  end
end
