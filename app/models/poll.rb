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

  has_one    :rating, as: :rateable, dependent: :destroy
  has_many   :downvoters, through: :rating, source: :downvoters
  has_many   :upvoters, through: :rating, source: :upvoters
  has_many   :options, dependent: :destroy
  has_many   :user_votes
  has_many   :voters, through: :user_votes, source: :user
  belongs_to :user

  serialize :vote_results, Array
  serialize :current_state, Array

  validates :title, presence: true
  validate  :max_voters_should_be_number
  validate  :date_should_be_in_future

  after_touch       :ensure_status_is_correct
  after_create      :create_rating

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
      self.current_state = calculate_ranks
      closed! if voters.count >= max_voters
      save!
    end
  end

  def accessible_for?(user)
    user_id == user.id
  end

  def options_in_rank
    current_state.each.with_index.each_with_object(Hash.new { |h, k| h[k] = [] }) { |(x, i), hash| hash[x] << options.ids[i] }
  end

  def max_voters
    self[:max_voters] || Float::INFINITY
  end

  private

  def calculate_ranks
    SchulzeBasic.do(vote_results, vote_results.first.count).ranks
  end

  def ensure_status_is_correct
    draft! if options.empty?
  end

  def max_voters_should_be_number
    errors.add(:max_voters, 'should be number greater than 0') unless (is_a?(Integer) || Float::INFINITY) && max_voters > 0
  end

  def date_should_be_in_future
    errors.add(:expire_at, 'should be in future') if expire_at&. < DateTime.now
  end
end
