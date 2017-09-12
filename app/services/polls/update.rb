# frozen_string_literal: true

module Services
  module Polls
    class Update
      # look up in concerns folder
      include Service

      def call(poll, params)
        poll_params = params.require(:poll).permit(:title, :max_voters, :expire_at)

        poll.update poll_params

        # send method to change status instead just changing value
        # to trigger all related checks and callbacks
        status = params['status']
        poll.send(status + '!') unless status.blank?

        poll
      end
    end
  end
end
