class RecipientListPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.includes(:mail_templates).where(mail_templates: { enabled: true })
          .or(scope.includes(:mail_templates)
            .where(mail_templates: { user: user }))
      end
    end
  end

  def index?
    true
  end

  def show?
    true
  end
end
