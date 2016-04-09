class Option < ActiveRecord::Base
  belongs_to :poll

  validates :title, presence: true
  validates :description, presence: true
end
