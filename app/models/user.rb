# frozen_string_literal: true
class User < ActiveRecord::Base
  has_secure_password

  has_many :polls, dependent: :destroy

  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_save :normalize_email
  before_create :create_activation_digest

  attr_accessor :remember_token, :activation_token, :reset_token

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.create_anonimous
    anonimous_token = SecureRandom.hex(8)
    create username: anonimous_token, email: "#{anonimous_token}@stub",
           password: anonimous_token, password_confirmation: anonimous_token,
           anonimous: true
  end

  def register(user_params)
    create_activation_digest
    update(user_params.merge(anonimous: false))
  end

  def correct_token?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def normalize_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
