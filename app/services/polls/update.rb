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

        destroy_options(poll, params)

        create_new_options(poll, params)

        poll
      end

      private

      # send method to change status instead just changing value
      # to trigger all related checks and callbacks
      def change_status(poll, params)
        status = params['status']
        poll.send(status + '!') unless status.blank?
      end

      def create_new_options(poll, params)
        new_options_params = params.permit(new_options: %i[title description])[:new_options]

        return unless new_options_params

        new_options_params.each do |param|
          poll.options.build(param)
          poll.options.map(&:save)
        end
      end

      def destroy_options(poll, params)
        ids_of_options_for_destroy = params.permit(ids_of_options_for_destroy: [])[:ids_of_options_for_destroy]
        poll.options.where(id: ids_of_options_for_destroy).destroy_all
      end
    end
  end
end
