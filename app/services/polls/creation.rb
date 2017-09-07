# frozen_string_literal: true

module Services
  module Polls
    class Creation
      # look up in concerns folder
      include Service

      def call(user, params)
        poll = prepare_poll_with_options(user, params)

        good_to_save = validate_poll_and_options(poll)

        save_poll_and_options(poll) if good_to_save

        poll_with_right_amount_of_options(poll)
      end

      private

      def poll_with_right_amount_of_options(poll)
        lack_of_options = Poll::MINIMUM_OPTIONS_COUNT - poll.options.size
        lack_of_options.times { poll.options.build }
        poll
      end

      def prepare_poll_with_options(user, params)
        poll_params = params.require(:poll).permit(:title, :max_voters, :expire_at, images: [])
        poll = user.polls.new(poll_params)
        prepare_options(poll, params)
        poll
      end

      def prepare_options(poll, params)
        options_params = params.permit(options: %i[title description]).require(:options)
        options_params.reject! { |option| option[:title].blank? && option[:description].blank? }
        build_options(poll, options_params)
      end

      def build_options(poll, options_params)
        options_params.each do |params|
          poll.options.build(params)
        end
      end

      def validate_poll_and_options(poll)
        poll.validate
        validate_options_count(poll)

        poll.errors.empty? && poll.options.map(&:valid?).all?
      end

      def validate_options_count(poll)
        return if poll.options.size >= Poll::MINIMUM_OPTIONS_COUNT
        poll.errors[:poll] << "should have at least #{Poll::MINIMUM_OPTIONS_COUNT} options"
      end

      def save_poll_and_options(poll)
        poll.save
        poll.options.map(&:save)
      end
    end
  end
end
