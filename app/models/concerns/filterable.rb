module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def filter(filtering_params)
      filtering_params.reject! do |_, value|
        value.compact_blank!.empty? # Remove empty strings and query for empty arrays
      end
      results = self.where(nil) # same as self.all
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end
