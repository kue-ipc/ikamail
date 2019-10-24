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
    case record.status
    when 'draft'
      writable?
    when 'pending'
      manageable?
    else
      false
    end
  end

  def destroy?
    # すでに番号が割り当てられている場合は削除不可
    record.status == 'draft' && record.number.nil? && writable?
  end

  def apply?
    record.status == 'draft' && writable?
  end

  def withdraw?
    record.status == 'pending' && record.user == user
  end

  def approve?
    record.status == 'pending' && manageable?
  end

  def reject?
    record.status == 'pending' && manageable?
  end

  def deliver?
    record.status == 'waiting' && record.delivery_timing == 'manual' && writable?
  end

  def cancel?
    record.status == 'waiting' && manageable?
  end

  def discard?
    record.status == 'draft' && !record.number.nil? && writable?
  end
end
