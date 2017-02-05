# frozen_string_literal: true
class AddAttachmentImageToPolls < ActiveRecord::Migration
  def self.up
    change_table :polls do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :polls, :image
  end
end
