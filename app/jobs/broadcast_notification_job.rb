# frozen_string_literal: true

class BroadcastNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    notification_html =
      NotificationsController.render :_notification, locals: { notification: notification }, layout: false
    ActionCable.server.broadcast "notifications_for_#{notification.user_id}", notification: notification_html
  end
end
