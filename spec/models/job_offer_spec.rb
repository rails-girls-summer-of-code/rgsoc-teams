require 'spec_helper'

describe JobOffer do
  context 'with validations' do
    it { should validate_presence_of(:company_name) }
    it { should validate_presence_of(:contact_email) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:title) }
  end
end
