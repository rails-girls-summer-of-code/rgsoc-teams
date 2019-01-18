class DestroyNonExistingGitHubUsers < ActiveRecord::Migration[5.1]
  def up
    return if ENV['RAILS_ENV'] == 'test'
    if ENV['RAILS_ENV'] == 'development'
      puts "Updating users with github_id ...."
      users = User.all.select { |user| user.github_id.nil? }
      users.each_with_index do |user, index|
        user.update!(github_id: index + 10)
      end
    else
      User.where(github_id: nil).destroy_all.each do |user|
        puts "removed user #{user.id} from database"
      end
    end
  end
end
