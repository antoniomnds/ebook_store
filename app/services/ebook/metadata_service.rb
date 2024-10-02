class Ebook
  class MetadataService
    class << self
      def get_summary(ebook)
        new(ebook).send(:get_summary)
      end
    end

    attr_reader :ebook

    def initialize(ebook)
      @ebook = ebook
    end


    private

    def get_summary
      ::Api::NewYorkTimes.fetch_summary(title: ebook.title)
    end
  end
end
