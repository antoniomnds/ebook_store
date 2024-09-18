class User < ApplicationRecord
  has_one :buyer
  has_one :seller
end
