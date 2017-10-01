# frozen_string_literal: true

module Services
  module Comments
    class Update
      # look up in concerns folder
      include Service
      include ImagesDestroyer

      def call(comment, params)
        comment_params = params.require(:comment).permit(:body, images: [])

        destroy_array_of_images(comment, params['ids_of_images_for_delete'])

        comment.update(comment_params)
      end
    end
  end
end
