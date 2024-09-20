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

  after_save_commit :resize_avatar,
                    if: -> { avatar.attached? }

  def resize_avatar
    ResizeImageJob.perform_later(self.class.name, self.id, :avatar, 250, 250)
  end
end
