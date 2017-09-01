# frozen_string_literal: true

class CreateUpvotes < ActiveRecord::Migration
  def change
    create_table :upvotes do |t|
      t.references :rating
      t.integer :rater_id

      t.timestamps null: false
    end
  end
end
