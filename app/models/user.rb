class User < ApplicationRecord
  has_many :matters, dependent: :destroy
  
  has_secure_password
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  
  def pending_matters
    matters.pending
  end
  
  def in_progress_matters
    matters.in_progress
  end
  
  def completed_matters
    matters.completed
  end
  
  def overdue_matters
    matters.overdue.where.not(state: 'completed')
  end
end