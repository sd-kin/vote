# frozen_string_literal: true

class AddEpireAtToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :expire_at, :datetime
  end
end
