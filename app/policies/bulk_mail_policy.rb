class BulkMailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.includes(:bulk_mail_template)
          .where(user: user)
          .or(scope.includes(:bulk_mail_template)
            .where(bulk_mail_templates: {user: user}))
      end
    end
  end

  def readbale?
    user.admin? ||
    record.bulk_mail_template.user == user ||
    record.user == user
  end

  def writable?
    user.admin? ||
    record.bulk_mail_template.user == user ||
    record.user == user
  end

  def manageable?
    user.admin? ||
    record.bulk_mail_template.user == user
  end

  def index?
    true
  end

  def show?
    readbale?
  end

  def create?
    true
  end

  def update?
    record.status == 'draft' && writable?
  end

  def destroy?
    record.status == 'draft' && writable?
  end

  def apply?
    record.status == 'draft' && writable?
  end

end
