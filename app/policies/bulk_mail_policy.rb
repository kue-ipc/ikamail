class BulkMailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.includes(:mail_template)
          .where(user: user)
          .or(scope.includes(:mail_template)
            .where(mail_templates: {user: user}))
      end
    end
  end

  def index?
    true
  end

  def show?
    readable?
  end

  def create?
    true
  end

  def update?
    (record.status_draft? && writable?) ||
      (record.status_pending? && manageable?)
  end

  def destroy?
    (record.status_draft? && writable?) ||
      (record.status_pending? && manageable?) ||
      (record.status_error? && record.number.nil? && writable?)
  end

  def apply?
    record.status_draft? && owned?
  end

  def withdraw?
    (record.status_pending? || record.status_ready? || record.status_reserved?) && owned?
  end

  def approve?
    (record.status_draft? || record.status_pending?) && manageable?
  end

  def reject?
    record.status_pending? && manageable?
  end

  def cancel?
    (record.status_reserved? || record.status_ready?) && manageable?
  end

  def reserve?
    record.status_ready? && writable?
  end

  def deliver?
    (record.status_ready? && record.delivery_timing_manual? && writable?) ||
      (record.status_failed? && writable?)
  end

  def discard?
    (record.status_failed? && writable?) ||
      (record.status_error? && writable?)
  end

  private def owned?
    record.user == user
  end

  private def readable?
    manageable? || owned?
  end

  private def writable?
    manageable? || owned?
  end

  private def manageable?
    user.admin? || record.mail_template.user == user
  end
end
