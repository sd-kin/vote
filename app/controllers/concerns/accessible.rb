# frozen_string_literal: true
module Accessible
  extend ActiveSupport::Concern

  def execute_if_accessible(subject: nil, redirect: true)
    return unless subject

    if subject.accessible_for?(current_user)
      yield(subject) if block_given?
    else
      flash[:error] = 'only owner can do that'
      redirect_to root_path if redirect
    end
  end
end
