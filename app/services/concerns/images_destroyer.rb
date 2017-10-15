# frozen_string_literal: true

module ImagesDestroyer
  def destroy_array_of_images(imegeable, ids_array)
    return unless imegeable && ids_array

    ids_array.each do |id|
      image = imegeable.images.find_by(id: id)

      next unless image

      image.destroy
    end
  end
end
