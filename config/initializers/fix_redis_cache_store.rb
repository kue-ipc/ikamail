# fix RedisCacheStore
# TODO: Remove this patch when Rails 8.1.2 or later is required.
if ENV.fetch("RAILS_CACHE_STORE", Settings.cache&.store) == "redis"
  require "fix_cache_redis_store"
  FixRedisCacheStore.load
end
