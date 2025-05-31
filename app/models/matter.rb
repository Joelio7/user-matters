class Matter < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :state, presence: true
  
  # Simple string validation instead of enum for now
  validates :state, inclusion: { in: %w[new in_progress completed] }
  
  def pending?
    state == 'new'
  end
  
  def in_progress?
    state == 'in_progress' 
  end
  
  def completed?
    state == 'completed'
  end
  
  def mark_in_progress!
    update!(state: 'in_progress')
  end
  
  def mark_completed!
    update!(state: 'completed')
  end
  
  # Scopes
  scope :pending, -> { where(state: 'new') }
  scope :in_progress, -> { where(state: 'in_progress') }
  scope :completed, -> { where(state: 'completed') }
  scope :due_today, -> { where(due_date: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :overdue, -> { where('due_date < ?', Time.current) }
  
  def overdue?
    due_date.present? && due_date < Time.current && !completed?
  end
end