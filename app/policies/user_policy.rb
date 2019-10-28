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
    admin? || user?
  end

  def admin?
    user.admin?
  end

  def user?
    user == record
  end
end
