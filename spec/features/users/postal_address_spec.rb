require 'rails_helper'

RSpec.describe 'Add Postal Address', type: :feature do
  let(:user) { create(:user) }
  let(:address) { create(:postal_address) }

  context 'signed in' do
    before { sign_in user }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      it 'allows creation of postal address if all required address fields are entered' do
        fill_in 'user_postal_addresses_address_line_1',    with: address.address_line_1
        fill_in 'user_postal_addresses_address_line_2',    with: address.address_line_2
        fill_in 'user_postal_addresses_city',              with: address.city
        fill_in 'user_postal_addresses_state_or_province', with: address.state_or_province
        fill_in 'user_postal_addresses_postal_code',       with: address.postal_code
        select address.country, from: 'user_postal_addresses_country'
        click_on 'Save'

        expect(current_path).to eq user_path(user)

        expect(page).to have_content address.address_line_1
        expect(page).to have_content address.address_line_2
        expect(page).to have_content address.city
        expect(page).to have_content address.state_or_province
        expect(page).to have_content address.postal_code
        expect(page).to have_content address.country
      end
    end
  end
end
