require 'spec_helper'

describe Team do
  it { should have_many(:activities) }
  it { should have_many(:repositories) }
  it { should have_many(:members) }
  it { should have_many(:students) }
  it { should have_many(:coaches) }
  it { should have_many(:mentors) }
  it { should have_many(:roles) }

  it { should validate_uniqueness_of(:name) }

  describe 'creating a new team' do
    before { subject.save! }

    it 'sets the team number' do
      subject.reload.number.should == 1
    end
  end
end
