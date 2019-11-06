class ActionLog < ApplicationRecord
  enum action: %i[
    create
    edit
    update
    destroy
    apply
    withdraw
    approve
    reject
    cancel
    reserve
    deliver
    finish
    discard
  ], _prefix: true

  belongs_to :bulk_mail
  belongs_to :user
end
