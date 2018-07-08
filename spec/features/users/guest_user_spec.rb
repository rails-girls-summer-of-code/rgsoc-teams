require 'rails_helper'

RSpec.describe 'Guest User', type: :feature do
  let!(:activity)       { create(:status_update, :published, team: team1) }
  let(:other_user)      { create(:user) }
  let!(:project)        { create(:project, :in_current_season, :accepted, submitter: other_user) }
  let!(:team1)          { create(:team, :in_current_season, name: 'Cheesy forever', project: project) }
  let!(:out_of_season)  { Season.current.starts_at - 1.week }
  let!(:summer_season)  { Season.current.starts_at + 1.week }

  context 'when visiting public pages' do
    context 'All Year' do
      before { Timecop.travel(out_of_season) }
      after  { Timecop.return }

      it 'can view Activities' do
        visit root_path
        expect(page).to have_css('h1', text: 'Activities')
        find('.title', match: :smart).click
        expect(page).to have_content(activity.title)
        expect(page).to have_content('You must be logged in to add a comment.')
      end

      it 'can view Community and User (no email addresses)' do
        visit community_path
        expect(page).to have_css('h1', text: 'Community')
        expect(page).not_to have_content(other_user.email)
        find_link(other_user.name, match: :smart).click
        expect(page).to have_content("About me")
        expect(page).to have_link("All participants")
        expect(page).not_to have_link("Edit") # check
      end

      it 'can view projects' do
        visit projects_path
        expect(page).to have_css('h1', text: 'Projects') # can be empty table
      end

      it 'has a nav menu with public links' do
        visit root_path
        expect(page).to have_link("Activities")
        find_link("Summer of Code").click
        expect(page).to have_link("Teams")
        expect(page).to have_link("Community")
        expect(page).to have_link("Help")
      end

      it 'has access to sign in link' do
        visit root_path
        expect(page).to have_link('Sign in')
      end
    end

    context 'in season' do
      before do
        Timecop.travel(summer_season)
      end
      after { Timecop.return }

      it "can view the current season's accepted and selected projects" do
        visit projects_path
        expect(page).to have_css('h1', text: 'Projects')
        find_link(project.name, match: :smart).click
        expect(page).to have_content project.description
        expect(page).not_to have_link("Edit")
      end
    end
  end
  # continuing story in: sign_in_unconfirmed_user || sign_in_confirmed_user || sign_in_fail
end
