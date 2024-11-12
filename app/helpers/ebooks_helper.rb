module EbooksHelper
  def cover_image_tag(ebook)
    return nil unless ebook.cover_image.attached?

    content_tag :div, class: "text-center mt-4", style: "height: 20rem" do
      if Rails.configuration.active_storage.service == :cloudinary
        cl_image_tag ebook.cover_image.key, width: 200, height: 300, crop: "scale"
      elsif Rails.configuration.active_storage.service == :local
        image_tag ebook.cover_image.variant(:thumb)
      end +
      content_tag(:hr)
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

  def purchase_button(ebook, klass: "btn btn-lg btn-outline-primary mt-5")
    if logged_in? && current_user.id != ebook.user_id && ebook.status_live?
        button_to "Purchase",
                  purchase_ebook_path(ebook),
                  method: :post,
                  class: klass,
                  data: { turbo_confirm: "Are you sure you want to purchase this ebook?" }
    end
  end

  def edit_ebook_button(ebook, klass: "btn btn-outline-primary")
    return nil unless current_user == ebook.user

    link_to "Edit this ebook",
            edit_ebook_path(ebook),
            class: klass
  end

  def delete_ebook_button(ebook, klass: "btn btn-outline-danger")
    return nil unless current_user == ebook.user

    button_to "Delete this ebook",
              ebook,
              method: :delete,
              class: klass,
              data: { turbo_confirm: "Are you sure you want to delete this ebook?" }
  end

  def ebook_summary_tag(review)
    return unless review

    content_tag :div, class: "mt-5 card", style: "width: 16rem;" do
      content_tag :div, class: "card-body" do
        content_tag(:h6, "New York Times Summary", class: "card-title") +
        content_tag(:div, review, class: "card-text")
      end
    end
  end
end
