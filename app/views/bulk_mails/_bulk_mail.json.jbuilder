json.extract! bulk_mail, :id, :template_id, :subject, :body, :user_id, :delivery_datetime, :number, :status, :created_at, :updated_at
json.url bulk_mail_url(bulk_mail, format: :json)
