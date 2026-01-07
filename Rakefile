# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

if ENV.fetch("RAILS_DATABESE_IN_MEMORY", Settings.database&.in_memory || "solid") == "redis"
  # FIXME: 予めredisをrequireしておかないと、RedisClient::NoScriptErrorの定義がおかしくなって、
  #    Redis::NoScriptErrorが定義されずに、エラーになる場合がある。
  #    どうやら"resque/scheduler/tasks"の中で"redis/errors"がrequireされるのが原因みたい。
  require "redis"

  require "resque/tasks"
  require "resque/scheduler/tasks"

  task "resque:setup" => :environment
end
