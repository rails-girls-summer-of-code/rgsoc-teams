require 'rails_helper'

RSpec.describe 'Unconfirmed User', type: :feature do
  let(:user) { create(:user, :unconfirmed) }

  let!(:activity)         { create(:status_update, :published, team: team1) }
  let(:other_user)        { create(:user, hide_email: false) }
  let(:hidden_email_user) { create(:user, hide_email: true) }
  let!(:project)          { create(:project, :in_current_season, :accepted, submitter: other_user) }
  let!(:team1)            { create(:team, :in_current_season, name: 'Cheesy forever', project: project) }
  let!(:out_of_season)    { Season.current.starts_at - 1.week }
  let!(:summer_season)    { Season.current.starts_at + 1.week }

  context "when signing in" do
    it 'gets access and is redirected to profile page' do
      visit root_path
      expect(page).to have_link('Sign in')

      # todo stub oath ; it should redirect to edit_users_path(user)
      # click_on ('Sign in')
      # and show 'authenticated' message:
      # expect(page).to have_content 'Successfully authenticated'

      sign_in(user)
      visit edit_user_path(user)
      expect(page).not_to have_link('Sign in')
      expect(page).to have_css('#user-links')
      expect(page).to have_content resend_info
      expect(page).to have_link('Click here to resend the email')
    end
  end

  context 'when sign in succeeded' do
    before do
      sign_in user
      visit edit_user_path(user)
    end

    it 'is redirected to profile' do
      expect(page).to have_content 'Edit your profile'
      find_field("Email", with: user.email)
      expect(page).to have_content("About you") # form field for About me
    end

    it 'can always update their email address' do
      expect(page).to have_content 'Edit your profile'
      email = find_field("Email", with: user.email)
      email.set("newemail@example.com")
      find_button("Save").click
      expect(page).to have_content("updated")
      expect(page).to have_content resend_info
      expect(page).to have_content("About me")
    end

    it 'user gets visual feedback when clicking on resend link' do
      find_link('Click here to resend the email.').click
      # todo: expect_to happen: something visible
    end
  end
  # story continues in: user_confirmed_via_link || user_resend_confirmation_mail || sign_in_fail
end

def resend_info
  "Please click on the link in the confirmation email to confirm your email address. Haven't received it? Click here
to resend the email."
end
