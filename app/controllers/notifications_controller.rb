# frozen_string_literal: true
class NotificationsController < ApplicationController
  def index
    if logged_in?
      notifications = current_user.notifications.includes(:subject)
      @notifications_hash = notifications.zip(notifications&.map(&:subject)).to_h
    else
      flash[:error] = 'you should log in to see notifications'
      redirect_to ready_polls_path
    end
  end
end
