class DestroyNonExistingGitHubUsers < ActiveRecord::Migration[5.1]
  def up
    unless ENV['RAILS_ENV'] == 'development'
      User.find_each do |user|
        if user.github_id == nil
          puts "removing user #{user.id} from database"
          user.destroy
        end
      end
    end
  end
end
