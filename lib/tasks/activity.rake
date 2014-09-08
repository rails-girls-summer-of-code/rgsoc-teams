require 'feed'

namespace :activity do
  desc 'Update activity'
  task update: :environment do
    Feed.update_all
  end
  end

  task set: :environment do
    team = Team.new(id: rand())

    project = Project.new(id: rand())
      project.id = team.id

  end

