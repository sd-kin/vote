class AddStatusToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :status, :string, null: false, default: 'draft'
  end
end
