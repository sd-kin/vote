# frozen_string_literal: true

class AddUserRefToPolls < ActiveRecord::Migration
  def change
    add_reference :polls, :user, index: true, foreign_key: true
  end
end
