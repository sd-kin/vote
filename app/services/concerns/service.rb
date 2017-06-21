# frozen_string_literal: true
module Service
  extend ActiveSupport::Concern

  module ClassMethods
    def call(*args)
      new.call(*args)
    end
  end
end
