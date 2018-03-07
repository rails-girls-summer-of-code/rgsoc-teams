class AddSubmittersAsMaintainers < ActiveRecord::Migration[5.1]
  def up
    accepted_projects.each do |project|
      project.maintainers << project.submitter
      say "Added #{project.submitter.name} (#{project.season.name}) to #{project.name}", true
    end
  end

  def down
  end

  private

  def accepted_projects
    Project
      .where.not(submitter: nil)
      .includes(:submitter, :season)
      .order(:season_id)
  end
end
