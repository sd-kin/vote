# frozen_string_literal: true
module Accessible
  extend ActiveSupport::Concern

  def execute_if_accessible(subject: nil, redirect: true)
    return unless subject

    if subject.accessible_for?(current_user)
      yield(subject) if block_given?
    else
      flash[:error] = 'only owner can do that'
      redirect_to url_for_subject(subject) if redirect
    end
  end

  private

  def url_for_subject(obj)
    obj.is_a?(Poll) ? ready_polls_path : url_for(obj)
  end
end
