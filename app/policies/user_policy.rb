class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || owner?
  end

  def create?
    admin?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    return false if record == user
    admin? && record.customer?
  end

  def can_assign_role?(target_role)
    user.can_manage_role?(target_role)
  end

  private

  def owner?
    record == user
  end

  def admin?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      case user.role
      when "admin"
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
