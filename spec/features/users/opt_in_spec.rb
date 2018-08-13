require 'rails_helper'

RSpec.describe 'Email opt in', type: :feature do
  let(:user)      { create(:user) }

  context 'signed in' do
    before { sign_in user }
    after { sign_out user }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      shared_examples 'opting in' do |optin|
        it 'allows opting in' do
          check "##{optin}"
          click 'Save'
          visit edit_user_path(user)
          expect(page.find("##{optin}")).to be_checked
        end
      end

      it_behaves_like 'opting in', :user_opted_in_newsletter
      it_behaves_like 'opting in', :user_opted_in_announcements
      it_behaves_like 'opting in', :user_opted_in_marketing_announcements
      it_behaves_like 'opting in', :user_opted_in_surveys
      it_behaves_like 'opting in', :user_opted_in_sponsorships
      it_behaves_like 'opting in', :user_opted_in_applications_open


      it 'is opted out of all email preferences by default' do
        expect(page.find('#user_opted_in_newsletter')).to_not be_checked
        expect(page.find('#user_opted_in_announcements')).to_not be_checked
        expect(page.find('#user_opted_in_marketing_announcements')).to_not be_checked
        expect(page.find('#user_opted_in_surveys')).to_not be_checked
        expect(page.find('#user_opted_in_sponsorships')).to_not be_checked
        expect(page.find('#user_opted_in_applications_open')).to_not be_checked
      end

    end
  end
end
