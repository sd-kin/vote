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

  def remember_user(user = current_user)
    user.remember
    cookies.signed.permanent[:user_id] = user.id
    cookies.signed[:remember_token] = { value: user.remember_token, expires: 1.month.from_now }
  end

  def forgot_user
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    current_user&.update_attribute(:remember_digest, nil)
  end

  def current_user
    @current_user ||= session[:user_id] ? user_from_session : user_from_cookie
    @current_user ||= create_anonimous!
  end

  def logged_in?
    !(current_user.nil? || current_user.anonimous?)
  end

  private

  def user_from_cookie
    user = User.find_by(id: cookies.signed[:user_id])
    user&.correct_token?(:remember, cookies.signed[:remember_token]) ? user : nil
  end

  def user_from_session
    User.find_by(id: session[:user_id])
  end

  def create_anonimous!
    user = User.create_anonimous!
    remember_user(user)
    log_in user
    user
  end
end
