# Load the Rails application.
require_relative "application"

case ENV.fetch("RAILS_DATABESE_IN_MEMORY", Settings.database&.in_memory || "solid")
in "solid"
  Bundler.require(:solid)
in "redis"
  Bundler.require(:redis)
in "memory"
  Rails.logger.debug("Using volatile database connections")
end

# Initialize the Rails application.
Rails.application.initialize!
