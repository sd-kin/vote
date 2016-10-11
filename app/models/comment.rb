# frozen_string_literal: true
class Comment < ActiveRecord::Base
  validates :body, presence: { message: 'of comment can not be empty' }

  belongs_to :commentable, polymorphic: true
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  has_many   :comments, as: :commentable

  def accessible_for?(user)
    user_id == user.id && !user.anonimous?
  end

  def destroy
    if comments.empty?
      super
    else
      errors.add(:base, 'Comment with replys can not be deleted')
      false
    end
  end
end
