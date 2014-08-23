class TeamsAddGithubHandle < ActiveRecord::Migration
  def change
    add_column :teams, :github_handle, :string
  end
end
