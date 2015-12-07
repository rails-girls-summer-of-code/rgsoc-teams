class AddFieldsToProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :team_id, :integer

    add_column :projects, :submitter_id, :integer
    add_column :projects, :season_id, :integer

    add_column :projects, :mentor_name, :string
    add_column :projects, :mentor_github_handle, :string
    add_column :projects, :mentor_email, :string

    add_column :projects, :url, :string
    add_column :projects, :description, :text
    add_column :projects, :issues_and_features, :text
    add_column :projects, :beginner_friendly, :boolean

    add_column :projects, :aasm_state, :string
  end
end
