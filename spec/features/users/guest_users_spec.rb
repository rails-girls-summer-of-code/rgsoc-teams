require 'rails_helper'

RSpec.describe 'Guest Users', type: :feature do
  let!(:user)          { create(:user) } # not the guest user; don't sign_in user
  let!(:project)       { create(:project, :in_current_season, :accepted, submitter: user) }
  let!(:team1)         { create(:team, name: 'Cheesy forever') }
  let!(:activity)     { create(:status_update, :published, team: team1) }
  let(:out_of_season) { Season.current.starts_at - 1.week }
  let(:summer_season) { Season.current.starts_at + 1.week }

  context "when visiting public pages" do

    context 'all year' do
      before { Timecop.travel(out_of_season) }
      after  { Timecop.return }

      it 'has restricted access to Activities page' do
        visit root_path
        expect(page).to have_css('h1', text: 'Activities')
        find('.title', match: :smart).click
        expect(page).to have_content(activity.title)
        expect(page).to have_content('You must be logged in to add a comment.')
      end

      it 'has restricted access to Community page' do
        visit community_path
        expect(page).to have_css('h1', text: 'Community')
        find_link(user.name, match: :first).click
        expect(page).to have_content("About me")
        expect(page).to have_link("All participants")
        expect(page).not_to have_link("Edit") # check
      end

      it 'has access to Projects page' do
        visit projects_path
        expect(page).to have_css('h1', text: 'Projects') # can be empty table
      end

      it 'has a menu with public links' do
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
        # story continues in sign_in_confirmed_user || sign_in_unconfirmed_user || sign_in_fail
      end
    end

    context 'in season' do
      before do
        Timecop.travel(summer_season)
        allow_any_instance_of(Project).to receive(:selected).and_return(:project)
      end
      after { Timecop.return }

      it 'has access to Projects index and show' do
        pending 'Stub needs updating; project not visible on page'
        visit projects_path
        expect(page).to have_css('h1', text: 'Projects')
        find_link(project.name, match: :smart).click
        expect(page).to have_content project.description
        expect(page).not_to have_link("Edit")
      end
    end
  end
end
