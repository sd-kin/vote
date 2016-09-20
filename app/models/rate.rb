# frozen_string_literal: true
class Rate < ActiveRecord::Base
  belongs_to :rating
  belongs_to :user, foreign_key: 'rater_id'
end
