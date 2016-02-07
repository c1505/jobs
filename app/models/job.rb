class Job < ActiveRecord::Base
  belongs_to :user
  validates :title, :company, :location, presence: true
end