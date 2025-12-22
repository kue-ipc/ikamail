require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ikamail
  VERSION = "1.0.0-alpha"

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local

    # config.eager_load_paths << Rails.root.join("extras")

    # pundit NotAuthorizedError => forbidden
    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden

    # mission_control-jobs configuration
    config.mission_control.jobs.base_controller_class = "AdminController"
    config.mission_control.jobs.http_basic_auth_enabled = false

    # Disable Active Storage variants.
    config.active_storage.variant_processor = :disabled
  end
end
