# frozen_string_literal: true

class AddAnonimousToUser < ActiveRecord::Migration
  def change
    add_column :users, :anonimous, :boolean, default: false
  end
end
