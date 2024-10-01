class User < ApplicationRecord
  has_one :buyer
  has_one :seller

  has_one_attached :avatar

  has_secure_password

  validates :username,
            presence: true

  validates :email,
            presence: true,
            email: true,
            uniqueness: true

  after_validation :set_password_expiration,
                   if: -> { password_digest_changed? }

  after_save_commit :resize_avatar,
                    if: -> { avatar.attached? }

  def password_expired?
    DateTime.now > password_expires_at
  end


  private

  def resize_avatar
    ResizeImageJob.perform_later(self.class.name, self.id, :avatar, 250, 250)
  end

  def set_password_expiration
    self.password_expires_at = Time.now + 6.months
  end
end
