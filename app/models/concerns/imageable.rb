# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :imageable, dependent: :destroy
  end

  def images=(images_array)
    images_array.each { |image| images.new(image_file: image) }
  end
end
