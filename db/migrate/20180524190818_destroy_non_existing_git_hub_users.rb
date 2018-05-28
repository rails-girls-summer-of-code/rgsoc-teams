class DestroyNonExistingGitHubUsers < ActiveRecord::Migration[5.1]
  def up
    unless ENV['RAILS_ENV'] == 'development'
      User.where(github_id: nil).destroy_all.each do |user|
        puts "removed user #{user.id} from database"
      end
    end
  end
end
