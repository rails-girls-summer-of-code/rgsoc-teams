namespace :team_project do
  desc 'Change project_name to project_id'
  task add_project_ids: :environment do
    Team.all.each do |team|
      next team unless team.project_name.present?
      begin
        team.project = Project.find_by(name: team.project_name)
        team.save!
      rescue
        Rails.logger "Adding project_id failed: #{e}, #{team}"
      end
    end
  end
end
