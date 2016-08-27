# frozen_string_literal: true
module Accessible
  extend ActiveSupport::Concern

  def execute_if_accessible(subject: nil, redirect: true)
    return unless subject

    if subject.accessible_for?(current_user)
      yield(subject) if block_given?
    else
      subject.errors.add(:access_denied, 'only owner can do that')
      redirect_to ready_polls_path if redirect
    end
  end
end
