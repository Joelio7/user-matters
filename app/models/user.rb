class User < ApplicationRecord
  has_many :matters, dependent: :destroy
  
  has_secure_password

  enum :role, {
    customer: 0,
    admin: 1
  }
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :role, presence: true
  validates :firm_name, presence: true, if: :admin?
  validates :firm_name, absence: true, if: :customer?

  def can_manage_role?(target_role)
    case role
      when 'admin'
        target_role == 'customer'
      else
        false
    end
  end
  
  def role_level
    case role
      when 'customer' then 0
      when 'admin' then 1
    end
  end
  
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