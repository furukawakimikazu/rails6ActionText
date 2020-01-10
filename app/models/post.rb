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
end
