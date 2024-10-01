module EbooksHelper
  def cover_image_tag(ebook)
    return nil unless ebook.cover_image.attached?

    if Rails.configuration.active_storage.service == :cloudinary
      cl_image_tag ebook.cover_image.key, width: 200, height: 300, crop: "scale"
    elsif Rails.configuration.active_storage.service == :local
      image_tag ebook.cover_image.variant(:thumb)
    end
  end
end
