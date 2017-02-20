class Image < ApplicationRecord

  has_attached_file                 :image_file, styles: { medium: '300x300>' }, default_url: ''
  validates_attachment_content_type :image_file, content_type: %r{\Aimage\/.*\z}

  belongs_to :imageable, polymorphic: true

  delegate :url, to: :image_file
end
