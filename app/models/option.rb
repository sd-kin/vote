# frozen_string_literal: true
class Option < ActiveRecord::Base
  belongs_to :poll

  validates :title, presence: true
  validates :description, presence: true

  after_create  :draft_poll!
  after_update  :draft_poll!
  after_destroy :draft_poll!

  def accessible_for?(user)
    poll.user_id == user.id
  end

  def draft_poll!
    poll.draft!
  end
end
