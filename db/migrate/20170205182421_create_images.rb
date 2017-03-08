# frozen_string_literal: true
class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true
      t.attachment :image_file

      t.timestamps
    end
  end
end
