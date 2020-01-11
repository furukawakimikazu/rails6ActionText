class Post < ApplicationRecord
  has_rich_text :content
  validates :title, length: { maximum: 32 }, presence: true

  validate :validate_content_length

  MAX_CONTENT_LNGTH = 50


  def validate_content_length
    length =  content.to_plain_text.length
    if length > MAX_CONTENT_LNGTH
      errors.add(
        :content,
        :too_long,
        max_content_length: MAX_CONTENT_LNGTH,
        length: length
      )
    end
  end

  validate :validate_content_body_attachables_byte_size

  ONE_KILOBYTE = 1024
  MEGA_BYTES = 4
  MAX_ATTACHABLES_BYTE_SIZE = MEGA_BYTES * 1000 * ONE_KILOBYTE

  def validate_content_body_attachables_byte_size
    attachable = content.body.attachables.grep(ActiveStorage::Blob).each do |attachable|
      if attachable.byte_size > MAX_ATTACHABLES_BYTE_SIZE
        errors.add(
          :base,
          :content_body_attachables_byte_size_is_too_big,
          max_content_attachment_mega_size: MEGA_BYTES,
          bytes: attachable.byte_size,
          max_bytes: MAX_ATTACHABLES_BYTE_SIZE
        )
      end
    end
  end

end
