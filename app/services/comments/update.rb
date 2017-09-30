# frozen_string_literal: true

module Services
  module Comments
    class Update
      # look up in concerns folder
      include Service

      def call(comment, params)
        comment_params = params.require(:comment).permit(:body, images: [])

        ids_of_images_for_delete = params['ids_of_images_for_delete']

        if ids_of_images_for_delete
          ids_of_images_for_delete.map(&:to_i)
          ids_of_images_for_delete.each do |id|
            comment.images.find(id).destroy
          end
        end

        comment.update(comment_params)
      end
    end
  end
end
