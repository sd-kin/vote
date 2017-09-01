# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :value, default: 0
      t.references :rateable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
