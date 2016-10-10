# frozen_string_literal: true
class Comment < ActiveRecord::Base
  validates :body, presence: { message: 'of comment can not be empty' }

  belongs_to :commentable, polymorphic: true
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  has_many   :comments, as: :commentable

  def accessible_for?(user)
    user_id == user.id && !user.anonimous?
  end
end
