# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.references :subject, polymorphic: true, index: true
      t.string :message

      t.timestamps null: false
    end
  end
end
