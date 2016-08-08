module Exporters
  class Projects < Base

    def current
      projects = Project.in_current_season.includes(:submitter)

      generate(projects, 'Project ID', 'Name', 'Submitter GH Handle', 'Mentor Name', 'Mentor GH Handle', 'Mentor Email', 'Website', 'Status', 'Tags') do |p|
        [p.id, p.name, p.submitter&.github_handle, p.mentor_name, p.mentor_github_handle, p.mentor_email, p.url, p.aasm_state, p.tags.sort.join(', ')]
      end
    end

  end
end
