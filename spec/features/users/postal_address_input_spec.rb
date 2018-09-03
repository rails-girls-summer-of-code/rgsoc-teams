require 'rails_helper'

RSpec.describe 'Postal address input', type: :feature do
  let(:user) { create(:user) }

  context 'signed in' do
    before { sign_in user }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      it 'allows address input for shipment' do
        visit edit_user_path(user)
        fill_in 'street', with: '123 Main St.'
        fill_in 'state', with: 'CO'
        fill_in 'zip', with: '12345'
        click 'Save'

        expect(current_path).to eq(user_path(user))

        expect(page).to have_content('123 Main St.')
        expect(page).to have_content('CO')
        expect(page).to have_content('12345')
      end
    end
  end
end
