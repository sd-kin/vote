# frozen_string_literal: true
class User < ActiveRecord::Base
  has_secure_password

  has_attached_file :avatar, styles: { medium: '300x300>' }
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

  has_one  :rating, as: :rateable, dependent: :destroy
  has_many :downvotes, foreign_key: 'rater_id'
  has_many :upvotes, foreign_key: 'rater_id'
  has_many :downvoters, through: :rating, source: :downvoters
  has_many :upvoters, through: :rating, source: :upvoters
  has_many :polls, dependent: :destroy
  has_many :user_votes
  has_many :voted_polls, through: :user_votes, source: :poll
  has_many :notifications
  has_many :comments, dependent: :restrict_with_error

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_save   :normalize_email
  before_create :create_activation_digest
  after_create  :create_rating # method added automatically by ActiveRecord becouse user has_one rating.

  scope :named, -> { where(anonimous: false) }

  attr_accessor :remember_token, :activation_token, :reset_token

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.create_anonimous!
    anonimous_token = SecureRandom.hex(8)
    create! username: anonimous_token, email: "#{anonimous_token}@stub",
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
