class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy

  validates :title, presence: true

  def ready!
    if options.empty? then errors.add(:status, "Can't be ready without options")
    else 
      self.status = 'ready'
      save
    end
  end

  def ready? 
    status == 'ready'
  end
end
