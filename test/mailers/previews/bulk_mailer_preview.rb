# Preview all emails at http://localhost:3000/rails/mailers/bulk_mailer
class BulkMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/bulk_mailer/all
  def all
    BulkMailer.all
  end

end
