# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ikamail
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # 日本限定
    config.time_zone = 'Osaka'
    config.active_record.default_timezone = :local

    # NotAuthorizedErrorは403にする。
    # initializersではだめっぽい。
    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden
  end
end
