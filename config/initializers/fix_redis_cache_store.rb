# fix RedisCacheStore
# TODO: Remove this patch when Rails 8.1.2 or later is required.
if Rails.application.config.cache_store == :redis_cache_store
  require "fix_redis_cache_store"
  FixRedisCacheStore.load
end
