# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# 4月1日にカウンターをリセットする。
every "0 0 1 4 *" do
  runner "ResetCountTemplateJob.perform_later"
end

every 1.day, at: ["6:00 am", "6:00 pm"] do
  runner "LdapMailSyncJob.perform_later"
end

every 1.day, at: "3:00 am" do
  runner "LdapUserSyncJob.perform_later"
end
