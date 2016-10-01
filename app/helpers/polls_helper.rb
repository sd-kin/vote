# frozen_string_literal: true
module PollsHelper
  def can_be_edited?(poll)
    poll.accessible_for?(current_user) && !poll.ready?
  end
end
