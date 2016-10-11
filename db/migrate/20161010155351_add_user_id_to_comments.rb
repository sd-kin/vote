# frozen_string_literal: true
class AddUserIdToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :user, index: true, foreign_key: true
  end
end