# frozen_string_literal: true
module Services
  module Polls
    class Creation
      # look up in concerns folder
      include Service

      def call(user, params)
        poll = prepare_poll(user, params)
        prepare_options(poll, params)

        # TODO: additional validate used because of && short circuit and do not evaluate validation
        # if left part evaluates to false, refactor that to look more clear. Get rid of side effects in
        # functions - options_valid? should only return boolean and not set errors or do anything else
        poll.validate

        save_poll_with_options(poll) if options_valid?(poll) && poll.valid?

        poll_with_options(poll)
      end

      private

      def poll_with_options(poll)
        lack_of_options = Poll::MINIMUM_OPTIONS_COUNT - poll.options.size
        lack_of_options.times { poll.options.build }
        poll
      end

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

      def options_valid?(poll)
        validate_options_count(poll) && validate_options(poll)
      end

      def validate_options_count(poll)
        if poll.options.size < Poll::MINIMUM_OPTIONS_COUNT
          poll.errors[:poll] << "should have at least #{Poll::MINIMUM_OPTIONS_COUNT} options"
          return false
        end
        true
      end

      def validate_options(poll)
        poll.options.map(&:valid?).all?
      end

      def save_poll_with_options(poll)
        poll.save
        poll.options.map(&:save)
      end
    end
  end
end
