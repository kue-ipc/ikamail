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

  delegate :admin?, to: :user

  def user?
    user == record
  end
end
