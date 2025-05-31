class User < ApplicationRecord
  has_many :matters, dependent: :destroy
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  def new_matters
    matters.status_new
  end
  
  def in_progress_matters
    matters.status_in_progress
  end
  
  def completed_matters
    matters.status_completed
  end
  
  def overdue_matters
    matters.overdue.where.not(state: 'completed')
  end
end