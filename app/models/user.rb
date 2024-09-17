class User < ApplicationRecord
  has_one :buyer
  has_one :seller

  validates :username,
            presence: true

  validates :email,
            presence: true,
            email: true

  validates :enabled,
    presence: true
end
