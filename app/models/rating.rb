# frozen_string_literal: true
class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true, autosave: true
  has_many :rates
  has_many :raters, through: :rates, source: :user, foreign_key: 'rater_id'

  def increase
    self.value += 1
    save
  end

  def decrease
    self.value -= 1
    save
  end
end
