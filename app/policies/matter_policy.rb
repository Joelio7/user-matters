class MatterPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    admin? || owner?
  end

  def create?
    true
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end

  def view_all_matters?
    admin?
  end

  def assign_to_others?
    admin?
  end

  def change_state?
    admin? || owner?
  end

  private

  def owner?
    record.user == user
  end

  def admin?
    user&.admin?
  end

  def customer?
    user&.customer?
  end

  class Scope < Scope
    def resolve
      case user.role
      when 'admin'
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end