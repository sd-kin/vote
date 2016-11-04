# frozen_string_literal: true
class Poll < ActiveRecord::Base
  require 'vote-schulze'
  require 'poll_status_machine'
  include PollStatusMachine

  # Source in PollStatusMachine concern
  availible_status_transitions draft:  { 'ready' => 'draft', 'finished' => 'draft', 'deleted' => 'draft' },
                               ready:  { 'draft' => 'ready' },
                               finish: { 'ready' => 'finished' },
                               delete: { 'draft' => 'deleted', 'ready' => 'deleted', 'finished' => 'deleted' }

  has_one    :rating, as: :rateable, dependent: :destroy
  has_many   :downvoters, through: :rating, source: :downvoters # users, who decrease poll rating
  has_many   :upvoters, through: :rating, source: :upvoters     # users, who increase poll rating
  has_many   :options, dependent: :destroy
  has_many   :user_votes
  has_many   :voters, through: :user_votes, source: :user       # users voted in this poll
  has_many   :comments, as: :commentable
  belongs_to :user

  serialize :vote_results, Array
  serialize :current_state, Array

  validates :title, presence: true
  validate  :max_voters_should_be_number
  validate  :date_should_be_in_future

  after_touch       :ensure_status_is_correct
  after_create      :create_rating
  after_find        :close_if_expire

  def vote!(user, preferences)
    if ready?
      transaction do
        save_votation_progress(user, preferences)
        finish! if voters.count >= max_voters
        save!
      end
    else
      errors.add(:base, 'only poll with ready status can be voted')
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
    # work just like standard numericality validation, but check [:max_voters] instead of .max_voters which return infinity
    errors.add(:max_voters, 'should be number greater than 0') unless (max_voters.is_a?(Integer) && max_voters > 0) || self[:max_voters].nil?
  end

  def date_should_be_in_future
    errors.add(:expire_at, 'should be in future') if expire_at&. < DateTime.now
  end

  def close_if_expire
    finish! if expire_at&. < DateTime.now
  end

  def status_machine
    @status_machine ||= configure_machine(status)
  end

  def drop_votation_progress
    update_attributes(current_state: [], vote_results: [], voters: [])
  end

  def save_votation_progress(user, preferences)
    voters << user
    vote_results << preferences
    self.current_state = calculate_ranks
  end
end
