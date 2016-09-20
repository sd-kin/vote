# frozen_string_literal: true
class RatingsController < ApplicationController
  before_action :set_user

  def increase
    @user.rating.increase
    render 'change_rating'
  end

  def decrease
    @user.rating.decrease
    render 'change_rating'
  end

  private

  def set_user
    @user = User.find params[:user_id]
  end
end
