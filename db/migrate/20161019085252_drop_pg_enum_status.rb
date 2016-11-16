# frozen_string_literal: true
class DropPgEnumStatus < ActiveRecord::Migration
  def up
    remove_column :polls, :status
    execute 'DROP TYPE status;'
  end

  def down
    execute <<-SQL
      CREATE TYPE status AS ENUM ('draft', 'ready', 'published', 'closed', 'deleted');
    SQL

    add_column :polls, :status, :status, default: 'draft'
  end
end
