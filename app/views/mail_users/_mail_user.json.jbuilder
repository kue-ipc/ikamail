json.extract! mail_user, :id, :name, :display_name, :mail, :created_at, :updated_at
json.url mail_user_url(mail_user, format: :json)
