# frozen_string_literal: true

module Services
  module Polls
    class Update
      # look up in concerns folder
      include Service
      include ImagesDestroyer

      def call(poll, params)
        poll_params = params.require(:poll).permit(:title, :max_voters, :expire_at, images: [])

        poll.update poll_params

        change_status(poll, params)

        destroy_array_of_images(poll, params['ids_of_images_for_delete'])

        poll
      end

      private

      # send method to change status instead just changing value
      # to trigger all related checks and callbacks
      def change_status(poll, params)
        status = params['status']
        poll.send(status + '!') unless status.blank?
      end
    end
  end
end
