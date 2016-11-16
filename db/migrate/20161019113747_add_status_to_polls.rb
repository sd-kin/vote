# frozen_string_literal: true
class AddStatusToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :status, :string, default: 'draft'
  end
end
