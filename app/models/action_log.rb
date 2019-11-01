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
    reserve
    deliver
    finish
    discard
  ]

  belongs_to :bulk_mail
  belongs_to :user
end
