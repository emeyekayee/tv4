# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "#{path}/log/cron.log"
#
every 1.day, at: "02:45" do
  command "/usr/local/bin/xtvd_load"
  # rake "some:great:rake:task"
end

every 1.day, at: "03:00" do
  runner "Program.do_after_xtvd_load"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
