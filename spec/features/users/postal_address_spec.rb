require 'rails_helper'

RSpec.describe 'Add Postal Address', type: :feature do
  let(:user) { create(:user) }
  let(:address) { create(:postal_address) }

  context 'signed in' do
    before { sign_in user }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      it 'allows creation of postal address if all required address fields are entered' do
        fill_in 'Line1', with: address.line1
        fill_in 'Line2', with: address.line2
        fill_in 'City',  with: address.city
        fill_in 'State', with: address.state
        fill_in 'Zip',   with: address.zip
        select address.country, from: 'Country'
        click_on 'Save'

        expect(current_path).to eq user_path(user)

        expect(page).to have_content address.line1
        expect(page).to have_content address.line2
        expect(page).to have_content address.city
        expect(page).to have_content address.state
        expect(page).to have_content address.zip
        expect(page).to have_content 'US'
      end

      it 'does not allow a postal address to be added if required fields are missing' do
        fill_in 'Line1',    with: address.line1
        fill_in 'Zip',       with: address.zip
        click_on 'Save'

        expect(page).to have_content "Postal address city can't be blank"
        expect(page).to have_content "Postal address country can't be blank"
      end
    end

    context 'when the user already has a postal address set up' do
      let!(:postal_address) { create(:postal_address, user: user) }

      it 'autofills saved postal address info on edit form if it exists' do
        visit edit_user_path(user)

        expect(page).to have_selector("input[value='#{user.postal_address.line1}']")
        expect(page).to have_selector("input[value='#{user.postal_address.city}']")
        expect(page).to have_selector("input[value='#{user.postal_address.state}']")
        expect(page).to have_selector("input[value='#{user.postal_address.zip}']")
      end

      it 'allows to delete an existing postal address' do
        visit edit_user_path(user)

        check 'user[postal_address_attributes][_destroy]'
        click_on 'Save'

        expect(current_path).to eq user_path(user)
        expect(page).to_not have_content postal_address.line1
        expect(page).to_not have_content postal_address.line2
        expect(page).to_not have_content postal_address.city
        expect(page).to_not have_content postal_address.state
        expect(page).to_not have_content postal_address.zip
      end
    end
  end
end
