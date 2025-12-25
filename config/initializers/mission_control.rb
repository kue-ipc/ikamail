# for mission_control-jobs

if Rails.application.config.active_job.queue_adapter == :solid_queue
  # mission_control-jobs configuration
  Rails.application.config.mission_control.jobs.base_controller_class = "AdminController"
  Rails.application.config.mission_control.jobs.http_basic_auth_enabled = false
end
