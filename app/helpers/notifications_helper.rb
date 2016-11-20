# frozen_string_literal: true
module NotificationsHelper
  def link_to_subject(subject)
    poll = find_poll_by(subject)
    link_to subject.class.to_s.downcase, poll_path(poll) + '#' + dom_id(subject)
  end

  def find_poll_by(subject)
    return subject if subject.is_a? Poll
    find_poll_by(subject.commentable)
  end
end
