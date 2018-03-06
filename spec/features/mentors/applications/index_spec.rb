require 'rails_helper'

RSpec.describe 'Application index page', type: :feature do
  let(:user)         { create(:user) }
  let(:project)      { create(:project, :in_current_season, :accepted, submitter: user) }
  let(:team1)        { create(:team, name: 'We could be Heroines') }
  let(:team2)        { create(:team, name: 'Electric Queen') }
  let(:application1) { create(:application, :in_current_season, :for_project, project1: project, team: team1) }
  let(:application2) { create(:application, :in_current_season, :for_project, project2: project, team: team2) }

  context 'when mentoring a single projcet' do
    before do
      application1
      application2
    end

    it 'displays the applications for this project' do
      login_as user

      visit mentors_applications_path

      expect(page).to have_table 'Teams applying for your projects this season.'

      expect(page).to have_link 'We could be Heroines'
      expect(page).to have_link 'Electric Queen'
    end
  end
end
