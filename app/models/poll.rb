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

  has_many :options, dependent: :destroy

  serialize :vote_results, Array
  serialize :current_state, Array

  validates :title, presence: true

  after_touch :ensure_status_is_correct

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

  def vote!
    vote = SchulzeBasic.do vote_results, vote_results.first.count
    self.current_state = vote.ranks
    save
  end

  def save_preferences_as_weight(arr)
    arr = arr.map { |opt| opt.split('_').last.to_i }.reverse
    vote_results << options.ids.map { |opt_id| arr.index opt_id }
    save
  end

  def options_in_rank
    res = []
    current_state.map.with_index { |x, i| res[x] = options.ids[i] }
    res.reverse!.map { |x| Option.find(x) }
  end

  private

  def ensure_status_is_correct
    draft! if options.empty?
  end
end
