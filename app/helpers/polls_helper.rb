# frozen_string_literal: true

module PollsHelper
  # code below assumes that will be only one available status, although it almost true for now
  # (except every status can be changed to deleted, but it handled by destroying object behavior,
  # not changing status) there no explicit limitation for that in other code, may be returning
  # array from one element will be more correct way to do that.
  def status_available_for(poll)
    return 'ready' if poll.able_to_ready?
    return 'draft' if poll.able_to_draft?
  end
end
