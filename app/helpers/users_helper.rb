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

  def password_challenge_tag(form)
    return nil if current_user.is_admin?

    content_tag :div, class: "row m-3" do
      form.label(:password_challenge,
                 "Current password",
                 style: "display: block",
                 class: "col-sm-2 col-form-label") + # concatenation needs enclosing parentheses
      content_tag(:div, class: "col-sm-10") do
        form.password_field :password_challenge, class: "form-control"
      end
    end
  end

  def user_enabled_tag(form)
    return nil unless current_user&.is_admin?

    content_tag :div, class: "row m-3" do
      content_tag(:div, class: "col-sm-10 offset-sm-2") do
        content_tag :div, class: "form-check" do
          form.check_box(:enabled, class: "form-check-input") +
            form.label(:enabled, style: "display: block", class: "form-check-label")
        end
      end
    end
  end
end
