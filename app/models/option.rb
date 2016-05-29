# frozen_string_literal: true
class Option < ActiveRecord::Base
  belongs_to :poll, touch: true

  validates :title, presence: true
  validates :description, presence: true
end
