# frozen_string_literal: true

module ImagesDestroyer
  def destroy_array_of_images(imegeable, ids_array)
    return unless imegeable && ids_array

    ids_array.each do |id|
      imegeable.images.find(id).destroy
    end
  end
end
