require 'rails_helper'

RSpec.describe 'Add Postal Address', type: :feature do
  let(:user) { create(:user) }
  let(:address) { create(:postal_address) }

  context 'signed in' do
    before { sign_in user }

    context 'in the user edit page' do
      before { visit edit_user_path(user) }

      it 'allows creation of postal address if all required address fields are entered' do
        fill_in 'user[postal_address_attributes][address_line_1]',    with: address.address_line_1
        fill_in 'user[postal_address_attributes][address_line_2]',    with: address.address_line_2
        fill_in 'user[postal_address_attributes][city]',              with: address.city
        fill_in 'user[postal_address_attributes][state_or_province]', with: address.state_or_province
        fill_in 'user[postal_address_attributes][postal_code]',       with: address.postal_code
        select address.country, from: 'user[postal_address_attributes][country]'
        click_on 'Save'

        expect(current_path).to eq user_path(user)

        expect(page).to have_content address.address_line_1
        expect(page).to have_content address.address_line_2
        expect(page).to have_content address.city
        expect(page).to have_content address.state_or_province
        expect(page).to have_content address.postal_code
        expect(page).to have_content user.postal_address.country
      end

      it 'does not allow a postal address to be added if required fields are missing' do
        expect(user.postal_address).to be_nil
        fill_in 'user[postal_address_attributes][address_line_1]',    with: address.address_line_1
        fill_in 'user[postal_address_attributes][postal_code]',       with: address.postal_code
        click_on 'Save'

        expect(page).to have_content "Postal address city can't be blank"
        expect(page).to have_content "Postal address country can't be blank"
      end

      it 'autofills saved postal address info on edit form if it exists' do
        user.update(postal_address: create(:postal_address))
        visit edit_user_path(user)

        expect(page).to have_selector("input[value='#{user.postal_address.address_line_1}']")
        expect(page).to have_selector("input[value='#{user.postal_address.city}']")
        expect(page).to have_selector("input[value='#{user.postal_address.state_or_province}']")
        expect(page).to have_selector("input[value='#{user.postal_address.postal_code}']")
      end

      it 'lets you delete an existing postal address' do
        user.update(postal_address: address)
        visit edit_user_path(user)

        accept_alert do
          click_on 'Remove Address'
        end

        expect(current_path).to eq user_path(user)

        expect(page).to_not have_content address.address_line_1
        expect(page).to_not have_content address.address_line_2
        expect(page).to_not have_content address.city
        expect(page).to_not have_content address.state_or_province
        expect(page).to_not have_content address.postal_code
      end
    end
  end
end
