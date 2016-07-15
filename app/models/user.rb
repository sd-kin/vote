# frozen_string_literal: true
class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_save :normalize_email

  def normalize_email
    email.downcase!
  end
end
