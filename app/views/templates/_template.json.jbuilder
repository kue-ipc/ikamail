json.extract! template, :id, :name, :recipient_list, :from_name, :from_mail_address, :subject_prefix, :subject_postfix, :body_header, :body_footer, :count, :reserved_time, :description, :created_at, :updated_at
json.url template_url(template, format: :json)
