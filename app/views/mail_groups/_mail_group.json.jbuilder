json.extract! mail_group, :id, :name, :display_name, :created_at, :updated_at
json.url mail_group_url(mail_group, format: :json)
