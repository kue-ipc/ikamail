require "active_support/cache/redis_cache_store"

# TODO: Remove this patch when Rails 8.1.2 or later is required.
module FixRedisCacheStore
  def self.load
    unless ActiveSupport::Cache::RedisCacheStore.private_instance_methods.include?(:_initialize)
      ActiveSupport::Cache::RedisCacheStore.alias_method :_initialize, :initialize
    end

    # fix initialize to accept ConnectionPool instance
    # https://github.com/rails/rails/pull/56292
    ActiveSupport::Cache::RedisCacheStore.class_eval do
      def initialize(error_handler: DEFAULT_ERROR_HANDLER, **redis_options)
        universal_options = redis_options.extract!(*UNIVERSAL_OPTIONS)
        redis = redis_options[:redis]

        already_pool = redis.instance_of?(::ConnectionPool) ||
                       (redis.respond_to?(:wrapped_pool) && redis.wrapped_pool.instance_of?(::ConnectionPool))

        if !already_pool && pool_options = self.class.send(:retrieve_pool_options, redis_options)
          @redis = ::ConnectionPool.new(**pool_options) { self.class.build_redis(**redis_options) }
        else
          @redis = self.class.build_redis(**redis_options)
        end

        @error_handler = error_handler

        super(universal_options)
      end
    end
  end
end
