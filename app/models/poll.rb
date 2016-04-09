class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy

  validates :title, presence: true
  validates :options, presence: true

end
