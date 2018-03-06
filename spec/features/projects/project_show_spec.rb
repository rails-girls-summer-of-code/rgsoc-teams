require 'rails_helper'

RSpec.describe 'Project show page', type: :feature do
  let(:project) { create(:project, name: 'The mighty Teams App', beginner_friendly: true) }

  it 'shows relevant info about the project and a link to go back to the list' do
    visit project_path(project)

    expect(page).to have_content 'The mighty Teams App'
    expect(page).to have_link 'All Projects'

    within('.qa-project-info') do
      expect(page).to have_content "Mentor #{project.mentor_name}"
      expect(page).to have_content "Project Website #{project.url}"
      expect(page).to have_content "Project Repository #{project.source_url}"
      expect(page).to have_content 'Suitable for Beginners? yes'

      expect(page).to have_content "State #{project.aasm_state}"
      expect(page).to have_content "Code of Conduct #{project.code_of_conduct}"
      expect(page).to have_content "License #{project.license}"
    end
  end

  context 'with applications for the project' do
    before do
      create(:application_draft, project1: project, state: 'applied')
      create(:application_draft, project2: project, state: 'applied')
      create_list(:application_draft, 2, project2: project, state: 'draft')
    end

    it 'show the current numbers for submitted and draft applications in the info table' do
      visit project_path(project)

      within('.qa-project-info') do
        expect(page).to have_content 'Applications (1st Choice) 1 (1 submitted | 0 in-progress)'
        expect(page).to have_content 'Applications (2nd Choice) 3 (1 submitted | 2 in-progress)'
      end
    end
  end
end
