# frozen_string_literal: true
class Option < ActiveRecord::Base
  belongs_to :poll, touch: true

  validates :title, presence: true
  validates :description, presence: true

  def accessible_for?(user)
    poll.user_id == user.id
  end

  def update(attributes)
    poll.draft!

    super(attributes)
  end

  def destroy
    poll.draft!

    super
  end
end
