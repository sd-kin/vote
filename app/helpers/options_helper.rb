# frozen_string_literal: true

module OptionsHelper
  def fields_name_for(option)
    option.new_record? ? 'new_options[][]' : 'options[][]'
  end
end
