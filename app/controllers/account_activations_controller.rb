# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user&.correct_token?(:activation, params[:id]) && !user.activated?
      user.update_attributes(activated: true, activated_at: Time.current)
      flash[:notice] = 'email confirmed'
      redirect_to ready_polls_path
    else
      flash[:error] = 'invalid link'
      redirect_to root_path
    end
  end
end
