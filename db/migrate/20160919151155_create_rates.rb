# frozen_string_literal: true
class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.references :rating
      t.integer    :rater_id

      t.timestamps null: false
    end
  end
end
