class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  def show?
    user.admin? || user == record
  end

  def sync?
    user.admin?
  end

  def admin?
    user.admin?
  end

  def user?
    user == record
  end
end
