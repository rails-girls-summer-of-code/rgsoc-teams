require 'selection/service/flag_applications'
require 'selection/service/application_distribution'

namespace :selection do
  desc 'Flag applications that do not match certain criteria'
  task flag_applications: :environment do
    Selection::Service::FlagApplications.new.call
  end

  desc 'Distribute Applications to Reviewers'
  task distribute_applications_to_reviewers: :environment do
    # need to filter eligible applications
    applications = Application.where(season: Season.current).shuffle

    applications.each do |application|
      begin
        Selection::Service::ApplicationDistribution.new(application: application).distribute
      rescue ActiveRecord::RecordInvalid => e
        puts "Error assigning Reviewers #{e}"
      end
    end
  end
end
