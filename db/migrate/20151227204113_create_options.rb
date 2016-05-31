# frozen_string_literal: true
class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
