require 'rails_helper'

RSpec.describe 'Communication', type: :feature do
  let(:user) { create(:user) }

  context 'signed in' do
    before { sign_in user }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      it 'has a link to sign up for the newsletter' do
        signup_link = find_link('Sign up for our newsletter')
        expect(signup_link[:href]).to eq('http://eepurl.com/gJ7D4r')
      end
    end
  end
end
