# frozen_string_literal: true
class PasswordResetsController < ApplicationController
  before_action :setup_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:alert] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:error] = "Email address not found"
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to ready_polls_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def setup_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.activated? && @user.correct_token?(:reset, params[:id])
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:error] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
