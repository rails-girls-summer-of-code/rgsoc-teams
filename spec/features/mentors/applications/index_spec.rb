require 'rails_helper'

RSpec.describe 'Application index page', type: :feature do
  let(:user)          { create(:user) }
  let(:project)       { create(:project, :in_current_season, :accepted, submitter: user) }
  let(:team1)         { create(:team, name: 'We could be Heroines') }
  let(:team2)         { create(:team, name: 'Electric Queen') }
  let!(:application1) { create(:application, :in_current_season, :for_project, project1: project, team: team1) }
  let!(:application2) { create(:application, :in_current_season, :for_project, project2: project, team: team2) }
  let(:mentor_phase)  { Season.current.applications_close_at + 1.day }

  before { Timecop.travel(mentor_phase) }

  after { Timecop.return }

  context 'when mentoring a single projcet' do
    it 'displays the applications for this project' do
      login_as user
      visit mentors_applications_path

      expect(page).to have_table 'Teams who submitted applications for your projects.'

      expect(page).to have_link 'We could be Heroines'
      expect(page).to have_link 'Electric Queen'
    end

    it 'allows to fav and unfav an application' do
      login_as user
      visit mentors_applications_path

      accept_prompt do
        find('.qa-fav', match: :first).click
      end

      expect(page).to have_content "Successfully fav'ed We could be Heroines's application."
      expect(application1.reload.application_data['mentor_fav_project1']).to eq 'true'

      accept_prompt do
        find('.qa-unfav', match: :first).click
      end

      expect(page).to have_content "Revoked your preference for We could be Heroines's application."
      expect(application1.reload.application_data['mentor_fav_project1']).to be_blank
    end
  end
end
