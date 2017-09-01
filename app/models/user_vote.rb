# frozen_string_literal: true

class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :poll

  validates :user_id, uniqueness: { scope: :poll_id }
end
