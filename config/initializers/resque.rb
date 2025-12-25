# for resque

if ENV.fetch("RAILS_QUEUE_ADAPTER", Settings.queue&.adapter) == "resque"
  require "resque"

  yaml_content = ERB.new(Rails.root.join("config/resque.yml").read).result
  resque_config = YAML.safe_load(yaml_content, permitted_classes: [Symbol], aliases: true)[Rails.env]
  Resque.redis = resque_config.fetch("url")
  Resque.redis.namespace = resque_config.fetch("namespace")

  Rails.application.config.after_initialize do
    # TODO: issueの対応状況に応じて変更すること
    # sinatra used by resque serevr, but dose not set permitted_hosts
    # https://github.com/resque/resque/issues/1908
    require "sinatra/base"
    class Sinatra::Base
      set :host_authorization, permitted_hosts: Rails.application.config.hosts.map(&:to_s)
    end
  end
end
