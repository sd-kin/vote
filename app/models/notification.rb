# frozen_string_literal: true
class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true
end
