class EbookSeller < ApplicationRecord
  belongs_to :seller
  belongs_to :ebook
end
