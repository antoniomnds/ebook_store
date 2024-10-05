class Ebook
  class MetadataService
    class << self
      def get_review(ebook)
        new(ebook).send(:get_review)
      end
    end

    attr_reader :ebook

    def initialize(ebook)
      @ebook = ebook
    end


    private

    def get_review
      ::Api::NewYorkTimes.fetch_review(title: ebook.title)
    end
  end
end
