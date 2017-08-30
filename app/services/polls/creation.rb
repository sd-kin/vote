module Services
  module Polls
    class Creation
      # look up in concerns folder
      include Service

      def call(user, params)
        poll_params    = params.require(:poll).permit(:title, :max_voters, :expire_at, images: [])
        options_params = params.permit(options: [:title, :description]).require(:options)

        create_poll(poll_params)
      end

      private

      def create_poll(poll_params)
        Poll.create(poll_params)
      end
    end
  end
end