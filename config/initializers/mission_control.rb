# for mission_control-jobs

if ENV.fetch("RAILS_QUEUE_ADAPTER", Settings.queue&.adapter) == "solid"
  # mission_control-jobs configuration
  Rails.application.config.mission_control.jobs.base_controller_class = "AdminController"
  Rails.application.config.mission_control.jobs.http_basic_auth_enabled = false
end
