module EbooksHelper
  def cover_image_tag(ebook)
    return nil unless ebook.cover_image.attached?

    if Rails.configuration.active_storage.service == :cloudinary
      cl_image_tag ebook.cover_image.key, width: 200, height: 300, crop: "scale"
    elsif Rails.configuration.active_storage.service == :local
      image_tag ebook.cover_image.variant(:thumb)
    end
  end

  def ebook_status_tag(ebook)
    case ebook.status
    when "archived"
      content_tag(:span, "Archived", class: "badge bg-danger")
    when "draft"
      content_tag(:span, "Draft", class: "badge bg-secondary")
    when "pending"
      content_tag(:span, "Pending", class: "badge bg-warning")
    when "live"
      content_tag(:span, "Available", class: "badge bg-success")
    else
      content_tag(:span, ebook.status&.titleize, class: "badge bg-info")
    end
  end
end
