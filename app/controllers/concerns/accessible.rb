# frozen_string_literal: true
module Accessible
  extend ActiveSupport::Concern

  def execute_if_accessible(object, redirect: true)
    if object.accessible_for?(current_user)
      yield(object) if block_given?
    else
      flash[:error] = 'only owner can do that'
      redirect_to root_path if redirect
    end
  end

  alias check_accessability execute_if_accessible
end
