module UsersHelper
  def avatar_tag(user)
    return nil unless user.avatar.attached?

    if Rails.configuration.active_storage.service == :cloudinary
      cl_image_tag user.avatar.key, width: 250, height: 250, crop: "scale"
    elsif Rails.configuration.active_storage.service == :local
      image_tag user.avatar.variant(resize_to_limit: [ 250, 250 ])
    end
  end

  def admin_tag(user)
    return nil unless user.is_admin?

    content_tag :span, "Admin", class: "badge bg-danger"
  end
end
