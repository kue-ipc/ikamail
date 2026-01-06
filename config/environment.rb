# Load the Rails application.
require_relative "application"

if ENV.fetch("RAILS_CACHE_STORE", Settings.cache&.store) == "solid" ||
    ENV.fetch("RAILS_QUEUE_ADAPTER", Settings.queue&.adapter) == "solid" ||
    ENV.fetch("RAILS_CABLE_ADAPTER", Settings.cable&.adapter) == "solid"
  Bundler.require(:solid)
end

if ENV.fetch("RAILS_CACHE_STORE", Settings.cache&.store) == "redis" ||
    ENV.fetch("RAILS_CABLE_ADAPTER", Settings.cable&.adapter) == "redis"
  Bundler.require(:redis)
end

if ENV.fetch("RAILS_QUEUE_ADAPTER", Settings.queue&.adapter) == "resque"
  Bundler.require(:resque)
  require "fix_redis_cache_store"
  FixRedisCacheStore.load
end

# Initialize the Rails application.
Rails.application.initialize!
