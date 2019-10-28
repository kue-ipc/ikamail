json.extract! action_log, :id, :bulk_mail_id, :action, :user_id, :comment, :created_at, :updated_at
json.url action_log_url(action_log, format: :json)
