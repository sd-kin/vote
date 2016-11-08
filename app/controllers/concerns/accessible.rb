# frozen_string_literal: true
module Accessible
  extend ActiveSupport::Concern

  def execute_if_accessible(object, redirect: true)
    if object.accessible_for?(current_user)
      yield(object) if block_given?
    else
      flash[:error] = 'only owner can do that'
      both_format_redirect if redirect
    end
  end

  private

  def both_format_redirect
    request.xhr? ? render( js: 'window.location = "/"' ) : redirect_to(root_path)
  end

  alias check_accessability execute_if_accessible
end
