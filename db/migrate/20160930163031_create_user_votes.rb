# frozen_string_literal: true
class CreateUserVotes < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.belongs_to :user
      t.belongs_to :poll

      t.timestamps null: false
    end
  end
end
