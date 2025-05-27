FactoryBot.define do
  factory :tagging do
    taggable factory: :ebook # have to be concrete so the factories_spec passes
    tag
  end
end
