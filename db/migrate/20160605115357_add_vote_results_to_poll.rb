# frozen_string_literal: true
class AddVoteResultsToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :vote_results, :text
  end
end
