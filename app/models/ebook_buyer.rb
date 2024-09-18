class EbookBuyer < ApplicationRecord
  belongs_to :buyer
  belongs_to :ebook
end
