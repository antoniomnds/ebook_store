class User < ApplicationRecord
  has_one :buyer
  has_one :seller
  has_one :user_profile
end
