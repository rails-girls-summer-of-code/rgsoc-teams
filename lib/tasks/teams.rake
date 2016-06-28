require 'feed'

namespace :teams do
  desc 'Notify teams to update their status log'
  task notify_missing_log_updates: :environment do
    # we do not send annoying emails on weekends:
    if !(Date.today.saturday? || Date.today.sunday?)
      TeamPerformance.teams_to_remind.each do |team|
        ReminderMailer.update_log(team).deliver_later
      end
    end
  end
end