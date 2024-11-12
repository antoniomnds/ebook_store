# frozen_string_literal: true

class Ebook
  class ReviewFetcher < ApplicationService
    attr_reader :ebook

    def initialize(ebook)
      @ebook = ebook
    end

    def call
      result = ::Api::NewYorkTimes::ReviewFetcher.call(title: ebook.title)
      result&.dig(0, "summary")
    end
  end
end
