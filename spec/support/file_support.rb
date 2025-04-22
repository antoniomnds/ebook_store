module FileSupport
  def expect_uploaded_file(object, attachable)
    aggregate_failures do
      expect(object.public_send("#{attachable}_attachment")).to be_a(ActiveStorage::Attachment)
      expect(object.public_send("#{attachable}_blob")).to be_a(ActiveStorage::Blob)
    end
  end
end
