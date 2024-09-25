class User < ApplicationRecord
  has_one :buyer,
          dependent: :nullify
  has_one :seller,
          dependent: :nullify
  has_many :ebooks,
           dependent: :nullify

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

  before_destroy :process_orphaned_ebooks,
                 prepend: true,
                 if: -> { ebooks.any? }

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

  def process_orphaned_ebooks
    # noinspection RailsParamDefResolve
    ebooks.update_all(status: :archived)
  end
end
