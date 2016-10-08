# frozen_string_literal: true
class AddUniqueIndexToUpvotes < ActiveRecord::Migration
  def change
    add_index :upvotes, [:rater_id, :rating_id], unique: true
  end
end
