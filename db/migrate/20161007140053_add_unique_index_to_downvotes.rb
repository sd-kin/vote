# frozen_string_literal: true

class AddUniqueIndexToDownvotes < ActiveRecord::Migration
  def change
    add_index :downvotes, %i[rater_id rating_id], unique: true
  end
end
