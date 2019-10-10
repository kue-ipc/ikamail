json.extract! bulk_mail_template, :id, :name, :recipient_list, :from_name, :from_mail_address, :subject_prefix, :subject_postfix, :body_header, :body_footer, :count, :reservation_hour, :reservation_minute, :description, :created_at, :updated_at
json.url bulk_mail_template_url(bulk_mail_template, format: :json)
