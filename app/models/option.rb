# frozen_string_literal: true
class Option < ActiveRecord::Base
  belongs_to :poll, touch: true

  validates :title, presence: true
  validates :description, presence: true

  after_update  :draft!
  after_destroy :draft!

  def accessible_for?(user)
    poll.user_id == user.id
  end

  def update(attributes)
    poll.draft!

    super(attributes)
  end

  def draft!
    poll.draft!
  end
end
