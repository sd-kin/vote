# frozen_string_literal: true
class Upvote < ActiveRecord::Base
  belongs_to :rating
  belongs_to :user, foreign_key: 'rater_id'
end
