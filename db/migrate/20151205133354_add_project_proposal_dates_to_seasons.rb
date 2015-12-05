class AddProjectProposalDatesToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :project_proposals_open_at, :datetime
    add_column :seasons, :project_proposals_close_at, :datetime
  end
end
