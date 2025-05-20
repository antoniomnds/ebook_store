require 'rails_helper'

RSpec.describe "users/_user", type: :view do
  it "shows the user's attributes" do
    user = build_stubbed(:user)
    allow(view).to receive(:admin_tag).with(user).and_return(nil)
    allow(view).to receive(:avatar_tag).with(user).and_return(nil)

    render locals: { user: }

    aggregate_failures do
      user.attributes.reject do |k, _|
        %w[ id password_digest password_expires_at admin disabled_at
            created_at updated_at ].include?(k)
      end.each do |k, v|
        expect(rendered).to include(k.titleize)
        expect(rendered).to include(v.to_s)
      end
    end
  end

  context "when the user owns ebooks" do
    it "has links to these ebooks" do
      user = create(:user, :with_live_ebooks)
      allow(view).to receive(:admin_tag).with(user).and_return(nil)
      allow(view).to receive(:avatar_tag).with(user).and_return(nil)

      render locals: { user: }

      aggregate_failures do
        user.ebooks.each do |ebook|
          expect(rendered).to have_link(ebook.title, href: ebook_path(ebook))
        end
      end
    end
  end
end
