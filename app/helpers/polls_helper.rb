# frozen_string_literal: true

module PollsHelper
  def status_availible_for(poll)
    return 'ready' if poll.able_to_ready?
    return 'draft' if poll.able_to_draft?
  end
end
