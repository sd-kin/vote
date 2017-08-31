# frozen_string_literal: true
module Services
  module Polls
    class Creation
      # look up in concerns folder
      include Service

      def call(user, params)
        poll = prepare_poll(user, params)

        return poll if poll.invalid?

        prepare_options(poll, params)

        save_poll_with_options(poll) if options_valid(poll)

        poll
      end

      private

      def prepare_poll(user, params)
        poll_params = params.require(:poll).permit(:title, :max_voters, :expire_at, images: [])
        poll = user.polls.new(poll_params)
      end

      def prepare_options(poll, params)
        options_params = params.permit(options: [:title, :description]).require(:options)
        options_params.reject! { |option| option[:title].blank? && option[:description].blank? }
        build_options(poll, options_params)
      end

      def build_options(poll, options_params)
        options_params.each do |params|
          poll.options.build(params)
        end
      end

      def options_valid(poll)
        poll.options.size >= Poll::MINIMUM_OPTIONS_COUNT && poll.options.all?(&:valid?)
      end

      def save_poll_with_options(poll)
        poll.save
        poll.options.map(&:save)
      end
    end
  end
end
