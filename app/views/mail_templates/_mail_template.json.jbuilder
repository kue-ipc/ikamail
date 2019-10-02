json.extract! mail_template, :id, :name, :recipient_list, :from_name, :from_mail_address, :subject_pre, :subject_post, :body_header, :body_footer, :count, :reservation_time, :description, :created_at, :updated_at
json.url mail_template_url(mail_template, format: :json)
