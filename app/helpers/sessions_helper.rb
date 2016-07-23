# frozen_string_literal: true
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forgot_user
    session.delete(:user_id)
    @current_user = nil
  end

  def remember_user
    cookies.signed.permanent[:user_id] = current_user.id
  end

  def forgot_user
    cookies.delete(:user_id)
  end

  def current_user
    user_id = session[:user_id] || cookies.signed[:user_id]
    @current_user ||= User.find_by(id: user_id)
  end

  def logged_in?
    !current_user.nil?
  end
end
