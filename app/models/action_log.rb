# frozen_string_literal: true

class ActionLog < ApplicationRecord
  enum action: {
    create: 0,
    edit: 1,
    update: 2,
    destroy: 3,
    apply: 4,
    withdraw: 5,
    approve: 6,
    reject: 7,
    deliver: 8,
    reserve: 9,
    cancel: 10,
    discard: 12,
    start: 13,
    finish: 14,
    fail: 15,
    error: 16,
  }, _prefix: true

  belongs_to :bulk_mail
  belongs_to :user, optional: true
end
