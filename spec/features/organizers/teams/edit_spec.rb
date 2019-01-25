require 'rails_helper'

RSpec.describe 'Editing Teams', type: :feature do
  let(:user)            { create(:organizer) }
  let(:season)          { Season.current }
  let(:past_season)     { create(:season, :past) }
  let(:team)            { create(:team, name: 'Team Yay', season: season) }
  let(:selection_phase) { season.applications_close_at + 1.day }
  let!(:exercism)       { create(:project, :accepted, name: 'Exercism', season: season) }

  before do
    create(:project, :accepted, name: 'Some Old Project', season: past_season)
    create(:project, name: 'Non-Accepted', season: season)
    create(:project, :accepted, name: 'Open Source Dropbox', season: season)

    Timecop.travel(selection_phase)
  end

  after { Timecop.return }

  it 'allows to set the project for a team (from the same season)' do
    login_as user
    visit edit_organizers_team_path(team)

    expect(page).not_to have_content('Some Old Project')
    expect(page).not_to have_content('Non-Accepted')
    expect(team.project).to be_nil

    select 'Exercism', from: 'Project'
    fill_in 'URL', with: 'https://example.com'
    click_on 'Save'

    expect(page).to have_content('Team was successfully updated')
    expect(page).to have_content('https://example.com')
    expect(team.reload.project).to eq(exercism)

    visit projects_path

    expect(page).to have_content('Non-Accepted')
    expect(page).to have_content('Open Source Dropbox')
    expect(page).to have_content('Exercism')
    expect(page).not_to have_content('Some Old Project')

    expect(page).to have_content('Team Yay')
  end
end
