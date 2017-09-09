# frozen_string_literal: true

module Services
  module Polls
    class Update
      # look up in concerns folder
      include Service

      def call(poll, params)
        poll_params = params.require(:poll).permit(:title)
        poll.update poll_params
        poll
      end
    end
  end
end
