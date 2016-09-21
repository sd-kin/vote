# frozen_string_literal: true
class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true, autosave: true
  has_many :downvotes
  has_many :upvotes
  has_many :downvoters, through: :downvotes, source: :user, foreign_key: 'rater_id'
  has_many :upvoters, through: :upvotes, source: :user, foreign_key: 'rater_id'

  def increase_by(user:)
    self.value += 1
    upvoters << user
    save
  end

  def decrease_by(user:)
    self.value -= 1
    downvoters << user
    save
  end
end
