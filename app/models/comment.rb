# frozen_string_literal: true
class Comment < ActiveRecord::Base
  validates :body, presence: { message: 'of comment can not be empty' }

  belongs_to :commentable, polymorphic: true
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  has_one    :rating, as: :rateable, dependent: :destroy
  has_many   :downvoters, through: :rating, source: :downvoters # users, who decrease comment rating
  has_many   :upvoters, through: :rating, source: :upvoters # users, who increase comment rating
  has_many   :comments, as: :commentable, dependent: :restrict_with_error

  after_create :create_rating # method added by ActiveRecord has_one

  def accessible_for?(user)
    user_id == user.id && !user.anonimous?
  end
end
