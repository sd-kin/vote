# frozen_string_literal: true
class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_save :normalize_email

  attr_accessor :remember_token

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def correct_token?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def normalize_email
    email.downcase!
  end
end
