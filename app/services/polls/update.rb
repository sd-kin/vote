# frozen_string_literal: true

module Services
  module Polls
    class Update
      # look up in concerns folder
      include Service

      def call(poll, params)
        poll_params = params.require(:poll).permit(:title, :max_voters, :expire_at, images: [])

        poll.update poll_params

        # send method to change status instead just changing value
        # to trigger all related checks and callbacks
        status = params['status']
        poll.send(status + '!') unless status.blank?

        ids_of_images_for_delete = params['ids_of_images_for_delete']

        if ids_of_images_for_delete
          ids_of_images_for_delete.map(&:to_i)
          ids_of_images_for_delete.each do |id|
            poll.images.find(id).destroy
          end
        end

        poll
      end
    end
  end
end
