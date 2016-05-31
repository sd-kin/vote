# frozen_string_literal: true
class AddSratusAsEnumToPolls < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE status AS ENUM ('draft', 'ready', 'published', 'closed', 'deleted');
    SQL

    add_column :polls, :status, :status, default: 'draft'
  end

  def down
    remove_column :polls, :status

    execute <<-SQL
      DROP TYPE gender;
    SQL
  end
end
