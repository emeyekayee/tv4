# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "#{path}/log/cron.log"
#
load_time  = "02:45"
load_time  = "03:15" if `hostname`.chomp == "mjc4"

after_load = "03:00"
after_load = "03:30" if `hostname`.chomp == "mjc4"

every 1.day, at: load_time do
  command "/usr/local/bin/xtvd_load"
  # rake "some:great:rake:task"
end

every 1.day, at: after_load do
  runner "Program.do_after_xtvd_load"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
