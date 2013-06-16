require 'feed'

namespace :feeds do
  desc 'Update all feeds'
  task update: :environment do
    Feed.update_all
  end
end
