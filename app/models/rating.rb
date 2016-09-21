# frozen_string_literal: true
class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true, autosave: true
  has_many :downvotes
  has_many :upvotes
  has_many :downvoters, through: :downvotes, source: :user, foreign_key: 'rater_id'
  has_many :upvoters, through: :upvotes, source: :user, foreign_key: 'rater_id'

  def increase_by(user:)
    if decreased_by?(user)
      self.value += 2
      downvoters.delete(user)
    else
      self.value += 1
    end
    upvoters << user
    save
  end

  def decrease_by(user:)
    if increased_by?(user)
      self.value -= 2
      upvoters.delete(user)
    else
      self.value -= 1
    end
    downvoters << user
    save
  end

  def decreased_by?(user)
    downvoters.include?(user)
  end

  def increased_by?(user)
    upvoters.include?(user)
  end
end
