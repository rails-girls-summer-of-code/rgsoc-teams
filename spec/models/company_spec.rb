require 'spec_helper'

describe Company do
  let(:owner) { FactoryGirl.create(:user) }
  subject { Company.new(name: 'Sloth GmbH', owner: owner) }

  it { should belong_to(:owner) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:owner_id) }
  it { should validate_uniqueness_of(:website) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner_id) }
end
