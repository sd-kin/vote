class AddCurrentStateToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :current_state, :string
  end
end
