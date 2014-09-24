require 'feed'

namespace :activity do
  desc 'Update activity'
  task update: :environment do
    Feed.update_all
  end
end