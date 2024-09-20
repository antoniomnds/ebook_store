class User < ApplicationRecord
  has_one :buyer
  has_one :seller

  has_one_attached :avatar

  validates :username,
            presence: true

  validates :email,
            presence: true,
            email: true

  validates :enabled,
    presence: true
end
