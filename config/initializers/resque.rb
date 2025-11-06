# sinatra

if ENV["RAILS_QUEUE_ADAPTER"] == "resque"
  config_file = Rails.root.join("config/resque.yml")
  resque_config = YAML.load(ERB.new(IO.read(config_file)).result)
  Resque.redis = resque_config[rails_env.to_s]
  Resque.redis.namespace = "ikamail:resque"

  Rails.application.config.after_initialize do
    # TODO: issueの対応状況に応じて変更すること
    # sinatra used by resque serevr, but dose not set permitted_hosts
    # https://github.com/resque/resque/issues/1908
    require "sinatra/base"
    class Sinatra::Base
      set :host_authorization, permitted_hosts: Rails.application.config.hosts.map(&:to_s)
    end

    esque.enqueue_to(:custom_queue, MyJob, arg1, arg2)
  end
end
