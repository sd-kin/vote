# frozen_string_literal: true
class Poll < ActiveRecord::Base
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

  private

  def ensure_status_is_correct
    draft! if options.empty?
  end
end
