require 'rails_helper'

RSpec.describe PostalAddress, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:line1)}
    it { is_expected.to validate_presence_of(:city)}
    it { is_expected.to validate_presence_of(:zip)}
    it { is_expected.to validate_presence_of(:country)}
  end
end
