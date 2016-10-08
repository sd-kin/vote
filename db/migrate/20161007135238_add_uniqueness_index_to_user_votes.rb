# frozen_string_literal: true
class AddUniquenessIndexToUserVotes < ActiveRecord::Migration
  def change
    add_index :user_votes, [:user_id, :poll_id], unique: true
  end
end
