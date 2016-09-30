# frozen_string_literal: true
class AddMaxVotersToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :max_voters, :integer, default: 100
  end
end
