require 'feed'

namespace :activity do
  desc 'Update activity'
  task update: :environment do
    Feed.update_all
  end
end


task set: :environment do
team = Team.find(params[:id])
project = Project.find(params[:id])

  team.id = project.id
end

