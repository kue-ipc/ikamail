json.extract! recipient_list, :id, :name, :display_name, :description, :created_at, :updated_at
json.url recipient_list_url(recipient_list, format: :json)
