# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :authorize_user, only: [:edit, :update]

  def index
    @users = User.named
  end

  def show
    @user = User.find params[:id]
    @rating = @user.rating
  end

  def new
    @user = User.new
  end

  def create
    @user = current_user
    if @user.register(user_params)
      UserMailer.account_activation(@user).deliver_later
      log_in @user
      redirect_to ready_polls_path
    else
      render :new
    end
  end

  def edit
    @user = User.find params[:id]
    @rating = @user.rating
    redirect_to edit_user_path(current_user) unless @user == current_user
  end

  def update
    @user = User.find params[:id]
    if @user == current_user && @user.update(user_params)
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find params[:id]
    if @user == current_user && @user.destroy
      redirect_to users_path
    else
      render :show
    end
  end

  private

  def authorize_user
    return if logged_in?
    flash[:error] = 'authentication needed'
    redirect_to login_path
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :avatar)
  end
end
