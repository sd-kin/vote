# frozen_string_literal: true
# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def session
      cookies.encrypted[Rails.application.config.session_options[:key]]
    end

    protected

    def find_verified_user
      if current_user = User.find_by(id: session['user_id'])
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end