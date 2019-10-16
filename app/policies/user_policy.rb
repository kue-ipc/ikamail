class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: current_user.id)
      end
    end
  end

  def admin?
    user? && user.admin?
  end

  def user?
    user == record
  end
end