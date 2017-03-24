require 'selection/service/flag_applications'

namespace :selection do
  desc 'Flag applications that do not match certain criteria'
  task flag_applications: :environment do
    Selection::Service::FlagApplications.new.call
  end
end
