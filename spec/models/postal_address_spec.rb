require 'rails_helper'

RSpec.describe PostalAddress, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { should_validate_presence_of(:address_line_1)}
    it { should_validate_presence_of(:city)}
    it { should_validate_presence_of(:postal_code)}
    it { should_validate_presence_of(:country)}
  end
end
