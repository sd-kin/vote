# frozen_string_literal: true
class RatingsController < ApplicationController
  before_action :set_user

  def increase
    @ratable.rating.increase_by(user: current_user)
    render 'change_rating'
  end

  def decrease
    @ratable.rating.decrease_by(user: current_user)
    render 'change_rating'
  end

  private

  def set_user
    resource, id = request.path.split('/')[1, 2]
    @ratable = resource.singularize.classify.constantize.find(id)
  end
end
