json.extract! bulk_mail, :id, :mail_template_id, :subject, :body, :user_id, :delivery_datetime, :number, :mail_status_id, :created_at, :updated_at
json.url bulk_mail_url(bulk_mail, format: :json)
