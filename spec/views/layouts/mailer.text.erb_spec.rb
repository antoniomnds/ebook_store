require 'rails_helper'

RSpec.describe "layouts/mailer", type: :view do
  it "yields view content" do
    # provide a view content and wrap it in the mailer layout
    render inline: "Dummy View Content",
           layout: self.class.top_level_description,
           formats: [ :text ]

    expect(rendered).to include("Dummy View Content")
  end
end
