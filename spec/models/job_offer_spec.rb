require 'spec_helper'

describe JobOffer do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:company_name) }
    it { is_expected.to validate_presence_of(:contact_email) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:title) }
  end
end
