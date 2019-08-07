# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :ldap do
  desc 'Start LDAP server'
  task :start do
    sh "ruby #{Rails.root.join('db', 'ldap', 'server.rb')} start"
  end

  desc 'Stop LDAP server'
  task :stop do
    sh "ruby #{Rails.root.join('db', 'ldap', 'server.rb')} stop"
  end

  desc 'Restart LDAP server'
  task :restart do
    sh "ruby #{Rails.root.join('db', 'ldap', 'server.rb')} restart"
  end

  desc 'Show satuts of LDAP server'
  task :status do
    sh "ruby #{Rails.root.join('db', 'ldap', 'server.rb')} status"
  end
end
