# frozen_string_literal: true

module ApplicationHelper
  def error_class?(object, field_name)
    'field-with-error' if object.errors[field_name].any?
  end
end
