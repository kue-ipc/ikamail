class I18n::Backend::ActiveRecord::TranslationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
