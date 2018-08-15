require 'rails_helper'

RSpec.describe 'Email opt in', type: :feature do
  let(:user)      { create(:user) }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      it 'allows optin in and out of email preferences' do
        expect(page.find('#user_opted_in_newsletter')).to_not be_checked
        expect(page.find('#user_opted_in_announcements')).to_not be_checked
        expect(page.find('#user_opted_in_marketing_announcements')).to_not be_checked
        expect(page.find('#user_opted_in_surveys')).to_not be_checked
        expect(page.find('#user_opted_in_sponsorships')).to_not be_checked
        expect(page.find('#user_opted_in_applications_open')).to_not be_checked

        find(:css, "#user_opted_in_applications_open").set(true)
        find(:css, "#user_opted_in_marketing_announcements").set(true)
        click_on 'Save'

        visit edit_user_path(user)
        expect(page.find('#user_opted_in_newsletter')).to_not be_checked
        expect(page.find('#user_opted_in_announcements')).to_not be_checked
        expect(page.find('#user_opted_in_marketing_announcements')).to be_checked
        expect(page.find('#user_opted_in_surveys')).to_not be_checked
        expect(page.find('#user_opted_in_sponsorships')).to_not be_checked
        expect(page.find('#user_opted_in_applications_open')).to be_checked

        find(:css, "#user_opted_in_applications_open").set(false)
        find(:css, "#user_opted_in_marketing_announcements").set(false)
        click_on 'Save'

        visit edit_user_path(user)
        expect(page.find('#user_opted_in_newsletter')).to_not be_checked
        expect(page.find('#user_opted_in_announcements')).to_not be_checked
        expect(page.find('#user_opted_in_marketing_announcements')).to_not be_checked
        expect(page.find('#user_opted_in_surveys')).to_not be_checked
        expect(page.find('#user_opted_in_sponsorships')).to_not be_checked
        expect(page.find('#user_opted_in_applications_open')).to_not be_checked
      end
    end
end
