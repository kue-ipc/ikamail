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
    cancel: 8,
    reserve: 9,
    deliver: 10,
    start: 11,
    finish: 12,
    fail: 13,
    error: 14,
    discard: 15,
  }, _prefix: true

  belongs_to :bulk_mail
  belongs_to :user
end
