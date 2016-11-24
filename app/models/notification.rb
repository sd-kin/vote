# frozen_string_literal: true
class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true

  after_create_commit :broadcast_notification

  private

  def broadcast_notification
    NotificationsChannel.notify(self)
  end
end
