# frozen_string_literal: true
class Comment < ActiveRecord::Base
  validates :body, presence: { message: 'of comment can not be empty' }

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
end
