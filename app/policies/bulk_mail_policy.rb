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

  def cancel?
    (record.status == 'reserved' || record.status == 'ready') && manageable?
  end

  def reserve?
    (record.status == 'reserved' || record.status == 'ready') && manageable?
  end

  def deliver?
    record.status == 'ready' && record.delivery_timing == 'manual' && writable?
  end

  def redeliver?
    record.status == 'ready' && record.delivery_timing == 'manual' && writable?
  end

  def discard?
    record.status == 'draft' && !record.number.nil? && writable?
  end
end
