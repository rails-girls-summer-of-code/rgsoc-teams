require 'rails_helper'

RSpec.describe 'Email opt in', type: :feature do
  let(:user)      { create(:user) }

  context 'signed in' do
    before { sign_in user }
    after { sign_out user }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      it 'is opted out of all email preferences by default' do
        expect(page.find('Newsletter Opt In')).to be_unchecked
        expect(page.find('Announcements')).to be_unchecked
        expect(page.find('Marketing Incentives')).to be_unchecked
        expect(page.find('Surveys')).to be_unchecked
        expect(page.find('Sponsorship and Coaching Companies ONLY')).to be_unchecked
        expect(page.find('Applications are Open Announcement ONLY')).to be_unchecked
      end

      #it 'can view Activities' do
        #visit root_path
        #expect(page).to have_css('h1', text: 'Activities')
        #find('.title', match: :smart).click
        #expect(page).to have_content(activity.title)
        #expect(page).to have_content('You must be logged in to add a comment.')
      #end

      #it 'can view Community and User (no email addresses)' do
        #visit community_path
        #expect(page).to have_css('h1', text: 'Community')
        #expect(page).not_to have_content(other_user.email)
        #find_link(other_user.name, match: :smart).click
        #expect(page).to have_content("About me")
        #expect(page).to have_link("All participants")
        #expect(page).not_to have_link("Edit") # check
      #end

      #it 'can view projects' do
        #visit projects_path
        #expect(page).to have_css('h1', text: 'Projects') # can be empty table
      #end

      #it 'has a nav menu with public links' do
        #visit root_path
        #expect(page).to have_link("Activities")
        #find_link("Summer of Code").click
        #expect(page).to have_link("Teams")
        #expect(page).to have_link("Community")
        #expect(page).to have_link("Help")
      #end

      #it 'has access to sign in link' do
        #visit root_path
        #expect(page).to have_link('Sign in')
      #end
    #end

    #context 'in season' do
      #before do
        #Timecop.travel(summer_season)
      #end
      #after { Timecop.return }

      #it "can view the current season's accepted and selected projects" do
        #visit projects_path
        #expect(page).to have_css('h1', text: 'Projects')
        #find_link(project.name, match: :smart).click
        #expect(page).to have_content project.description
        #expect(page).not_to have_link("Edit")
      #end
    end
  end
  # continuing story in: sign_in_unconfirmed_user || sign_in_confirmed_user || sign_in_fail
end
