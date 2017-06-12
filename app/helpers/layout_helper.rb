# frozen_string_literal: true
module LayoutHelper
  def render_account_links
    if logged_in?
      render 'layouts/logged_header_links'
    else
      render 'layouts/non_logged_header_links'
    end
  end
end
