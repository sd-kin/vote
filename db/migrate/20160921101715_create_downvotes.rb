# frozen_string_literal: true
class CreateDownvotes < ActiveRecord::Migration
  def change
    create_table :downvotes do |t|
      t.references :rating
      t.integer :rater_id

      t.timestamps null: false
    end
  end
end
