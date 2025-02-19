class User < ApplicationRecord
  has_one :buyer
  has_one :seller
  has_many :ebooks

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

  scope :with_ebooks, -> { joins(:ebooks).distinct.order(:id) }

  def password_expired?
    DateTime.now > password_expires_at
  end

  def disabled?
    !enabled?
  end

  # Performs a soft delete on the user.
  def disable!
    ActiveRecord::Base.transaction do
      time = DateTime.now
      timestamp = time.to_i
      update!(
        enabled: false,
        username: "deleted-user-#{ timestamp }",
        email: "#{ timestamp }@deleted-user",
        disabled_at: time
      )
      # noinspection RailsParamDefResolve
      ebooks.update_all(status: :archived, updated_at: time)
    end
  end

  private

  def resize_avatar
    ResizeImageJob.perform_later(self.class.name, self.id, :avatar, 250, 250)
  end

  def set_password_expiration
    self.password_expires_at = Time.now + 6.months
  end
end
