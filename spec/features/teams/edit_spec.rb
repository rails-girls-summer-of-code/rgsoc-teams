require 'rails_helper'

RSpec.describe 'Editing Teams', type: :feature do
  let(:user) { create(:user) }

  before do
    create(:role, name: 'student', team: team, user: user)
    login_as user
  end

  context 'when the team has been accepted and a project assigned' do
    let(:team)    { create(:team, kind: 'full_time', project: project) }
    let(:project) { create(:project, name: 'Unicorn Prompt') }

    it 'displays a readonly field for the project' do
      visit edit_team_path(team)

      expect(page).to have_field('Project', with: project.id, disabled: true)
      expect(page).to have_content('Unicorn Prompt')
    end
  end

  context 'when the team has been accepted but no project assigned yet' do
    let(:team) { create(:team, kind: 'full_time', project: nil) }

    it 'displays an empty readonly field for the project' do
      visit edit_team_path(team)

      expect(page).to have_field('Project', with: nil, disabled: true)
    end
  end
end
