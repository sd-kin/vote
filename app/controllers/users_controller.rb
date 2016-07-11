# frozen_string_literal: true
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to ready_polls_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
