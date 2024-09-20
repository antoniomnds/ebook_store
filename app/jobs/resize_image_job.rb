class ResizeImageJob < ApplicationJob
  queue_as :default

  def perform(class_name, record_id, attachment_name, width, height)
    klass = Object.const_get(class_name)
    record = klass.find(record_id)
    attachment = record.__send__(attachment_name)
    return unless attachment.attached?

    attachment.variant(resize_to_limit: [ width, height ]).processed # process and cache the variant
  end
end
