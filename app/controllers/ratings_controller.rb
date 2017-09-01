# frozen_string_literal: true

class RatingsController < ApplicationController
  before_action :set_rating, :collect_errors

  def increase
    @rating.increase_by(user: current_user)
    render 'change_rating'
  end

  def decrease
    @rating.decrease_by(user: current_user)
    render 'change_rating'
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def collect_errors
    flash[:error] = @rating.errors.full_messages if @rating.errors.any?
  end
end
