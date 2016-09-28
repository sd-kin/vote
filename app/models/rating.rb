# frozen_string_literal: true
class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true, autosave: true
  has_many :downvotes
  has_many :upvotes
  has_many :downvoters, through: :downvotes, source: :user, foreign_key: 'rater_id'
  has_many :upvoters, through: :upvotes, source: :user, foreign_key: 'rater_id'

  def increase_by(user:)
    transaction do
      upvoters << user

      if decreased_by?(user)
        cancel_transaction unless downvoters.delete(user)
        self.value += 2
      else
        self.value += 1
      end

      save
    end
  end

  def decrease_by(user:)
    transaction do
      downvoters << user

      if increased_by?(user)
        cancel_transaction unless upvoters.delete(user)
        self.value -= 2
      else
        self.value -= 1
      end

      save
    end
  end

  def decreased_by?(user)
    downvoters.include?(user)
  end

  def increased_by?(user)
    upvoters.include?(user)
  end

  private

  def cancel_transaction
    errors.add :base, 'previos choise can not be declined'
    raise ActiveRecord::Rollback
  end
end
