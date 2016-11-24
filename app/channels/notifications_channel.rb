# frozen_string_literal: true
# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'notification_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.notify(notification)
    notification_html =
      NotificationsController.render :_notifications, locals: { notifications_hash: { notification => notification.subject } }, layout: false
    ActionCable.server.broadcast 'notification_channel', notification: notification_html
  end
end
