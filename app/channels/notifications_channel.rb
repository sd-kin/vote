# frozen_string_literal: true
# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_for_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.notify(notification, user)
    notification_html =
      NotificationsController.render :_notifications, locals: { notifications_hash: { notification => notification.subject } }, layout: false
    ActionCable.server.broadcast "notifications_for_#{user.id}", notification: notification_html
  end
end
