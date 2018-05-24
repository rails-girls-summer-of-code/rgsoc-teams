class DestroyNonExistingGitHubUsers < ActiveRecord::Migration[5.1]
  def up
    execute 'DELETE FROM users WHERE github_id IS NULL'
  end
end
