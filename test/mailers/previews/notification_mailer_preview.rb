# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/apply
  def apply
    NotificationMailer.apply
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/withdraw
  def withdraw
    NotificationMailer.withdraw
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/approve
  def approve
    NotificationMailer.approve
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/reject
  def reject
    NotificationMailer.reject
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/deliver
  def deliver
    NotificationMailer.deliver
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/cancel
  def cancel
    NotificationMailer.cancel
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/discard
  def discard
    NotificationMailer.discard
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/finish
  def finish
    NotificationMailer.finish
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/error
  def error
    NotificationMailer.error
  end

end
