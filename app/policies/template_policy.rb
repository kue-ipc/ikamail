class TemplatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
