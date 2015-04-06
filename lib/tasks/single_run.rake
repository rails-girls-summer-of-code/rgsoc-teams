namespace :single_run do
  desc '2015-04-06: Migrate data entered into Teams#description to ApplicationDraft#project_plan'
  task copy_team_description_to_application_draft: :environment do
    ApplicationDraft.includes(:team).each do |draft|
      draft.update_attribute(:project_plan, draft.team.description) if draft.team
    end
  end
end
