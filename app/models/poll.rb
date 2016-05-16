class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy

  validates :title, presence: true

  after_touch :ensure_status_is_correct

  def ready!
    if options.empty? then errors.add(:status, "can't be ready when poll have no options")
    else 
      self.status = 'ready'
      save
    end
  end

  def ready? 
    status == 'ready'
  end

  private 

  def ensure_status_is_correct
    self.status = 'draft' if options.empty?
    save
  end
end
