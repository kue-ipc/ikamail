require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ikamail
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # 日本限定
    config.time_zone = 'Osaka'
    config.active_record.default_timezone = :local

    # NotAuthorizedErrorは403にする。
    # initializersではだめっぽい。
    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden
  end
end
