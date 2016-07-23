# frozen_string_literal: true
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: session_params[:email]
    if user&.authenticate(session_params[:password])
      log_in(user)
      remember_user
      redirect_to ready_polls_path
    else
      flash.now[:error] = "Error! Email or password incorrect"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
