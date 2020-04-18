require 'rails_helper'

RSpec.describe 'Application show page', type: :feature do
  let(:user)         { create(:user) }
  let(:project)      { create(:project, :in_current_season, :accepted, submitter: user) }
  let(:team)         { create(:team, name: 'We could be Heroines') }
  let(:application)  { create(:application, :in_current_season, :for_project, project1: project, student0_name: 'Patty', student1_name: 'Marcie', team: team) }
  let(:mentor_phase) { Season.current.applications_close_at + 1.day }

  before { Timecop.travel(mentor_phase) }

  after { Timecop.return }

  it 'displays parts of the application and a place to leave comments' do
    login_as user

    visit mentors_application_path(application)

    expect(page).to have_content 'Team We could be Heroines'
    expect(page).to have_content 'Patty'
    expect(page).to have_content 'Marcie'

    expect(page).to have_content 'Why did you select this project? (1st project)'
    expect(page).to have_content 'Which features are you planning to work on? (1st project)'

    expect(page).to have_content 'What is your programming level?', count: 2
    expect(page).to have_content 'Provide examples of your code', count: 2
    expect(page).to have_content 'What you have been doing to learn programming', count: 2
    expect(page).to have_content 'For how many months have you been learning the language of your primary project?', count: 2
    expect(page).to have_content 'Short summary of your programming skills', count: 2

    expect(page).to have_button 'Create Comment'
  end

  it 'lets the mentor create a comment' do
    login_as user

    visit mentors_application_path(application)

    fill_in 'My Comment', with: 'Test Comment'
    click_button 'Create Comment'

    expect(page).to have_content 'Test Comment'
  end

  it 'lets the mentor update a comment' do
    login_as user

    visit mentors_application_path(application)

    fill_in 'My Comment', with: 'Test Comment'
    click_button 'Create Comment'

    expect(page).to have_content 'Test Comment'

    fill_in 'My Comment', with: 'Updated Comment'
    click_button 'Update Comment'

    expect(page).to have_content 'Updated Comment'
  end

  context 'when the project is 2nd choice' do
    let(:application) { create(:application, :in_current_season, :for_project, project2: project, team: team) }

    it 'makes it obvious the project was the 2nd choice' do
      login_as user

      visit mentors_application_path(application)

      expect(page).to have_content 'Team We could be Heroines'

      expect(page).to have_content 'Why did you select this project? (2nd project)'
      expect(page).to have_content 'Which features are you planning to work on? (2nd project)'
    end
  end
end
