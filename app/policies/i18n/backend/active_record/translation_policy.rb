module I18n
  module Backend
    class ActiveRecord
      class TranslationPolicy < ApplicationPolicy
        class Scope < Scope
          def resolve
            scope.all
          end
        end
      end
    end
  end
end
