# frozen_string_literal: true
class Poll < ActiveRecord::Base
  require 'vote-schulze'

  enum status: {
    draft:     'draft',
    ready:     'ready',
    published: 'published',
    closed:    'closed',
    deleted:   'deleted'
  }

  has_one  :rating, as: :rateable, dependent: :destroy
  has_many :downvoters, through: :rating, source: :downvoters
  has_many :upvoters, through: :rating, source: :upvoters
  has_many :options, dependent: :destroy
  has_many :user_votes
  has_many :voters, through: :user_votes, source: :user
  belongs_to :user

  serialize :vote_results, Array
  serialize :current_state, Array

  validates :title, presence: true

  after_touch :ensure_status_is_correct
  after_create :create_rating

  def ready!
    if options.empty?
      errors.add(:status, "can't be ready when poll have no options")
    else
      self.vote_results = []
      self.current_state = []
      super
    end
  end

  def draft!
    self.vote_results = []
    self.current_state = []
    super
  end

  def vote!(user:, preferences:)
    transaction do
      voters << user
      vote_results << preferences
      vote = SchulzeBasic.do vote_results, vote_results.first.count
      self.current_state = vote.ranks
      save!
    end
  end

  def accessible_for?(user)
    user_id == user.id
  end

  def options_in_rank
    current_state.each.with_index.each_with_object(Hash.new { |h, k| h[k] = [] }) { |(x, i), hash| hash[x] << options.ids[i] }
  end

  private

  def ensure_status_is_correct
    draft! if options.empty?
  end
end
