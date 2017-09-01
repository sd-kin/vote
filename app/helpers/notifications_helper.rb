# frozen_string_literal: true

module NotificationsHelper
  def link_to_subject(subject)
    return unless subject
    poll = subject.is_a?(Poll) ? subject : subject.root.commentable_id
    link_to subject.class.to_s.downcase, poll_path(poll, anchor: dom_id(subject))
  end
end
