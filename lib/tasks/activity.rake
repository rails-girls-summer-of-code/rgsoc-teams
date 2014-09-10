require 'feed'

namespace :activity do
  desc 'Update activity'
  task update: :environment do
    Feed.update_all
  end
  end

  task set: :environment do
    Team.all do |team|
      project = Project.create(name: team.projects, id: team_id)
      puts "#{project.id}"
      puts "#{team.all.count}"
    end

  end

