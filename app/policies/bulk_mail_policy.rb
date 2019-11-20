# frozen_string_literal: true

class BulkMailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.includes(:template)
             .where(user: user)
             .or(scope.includes(:template)
               .where(templates: {user: user}))
      end
    end
  end

  def readable?
    user.admin? ||
      record.template.user == user ||
      record.user == user
  end

  def writable?
    user.admin? ||
      record.template.user == user ||
      record.user == user
  end

  def manageable?
    user.admin? ||
      record.template.user == user
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
    record.status_draft? && record.number.nil? && writable?
  end

  def apply?
    record.status_draft? && writable?
  end

  def withdraw?
    record.status_pending? && record.user == user
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
    (record.status_reserved? || record.status_ready?) && manageable?
  end

  def deliver?
    record.status_ready? && record.delivery_timing_manual? && writable?
  end

  def redeliver?
    record.status_ready? && record.delivery_timing_manual? && writable?
  end

  def discard?
    record.status_draft? && !record.number.nil? && writable?
  end
end
