# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
env :PATH, ENV['PATH']
set :output, 'log/cron.log'
set :environment, :production
# set :environment, :development

# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
#JSTは+9:00なので18:00
# every 1.days, at: '9:00 am' do
every 2.minutes do
  runner "MorningActiveMailer.check_notice_mail.deliver_now"
end
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


# 1. 設定内容が問題ないか確認
# $ RAILS_ENV=production bundle exec whenever

# 2. crontabに反映する
# $ RAILS_ENV=production bundle exec whenever --update-crontab

# 3. crontabに反映した内容の確認
# $ RAILS_ENV=production crontab  -l

# 4. crontabに反映した内容を削除
# $ RAILS_ENV=production bundle exec whenever --clear-crontab

# 2.4のコマンドを繰り返し、バッチ処理の再開、停止を繰り返す!!