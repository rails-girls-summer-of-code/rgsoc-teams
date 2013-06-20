require 'spec_helper'

describe Team do
  subject { Team.new(kind: 'sponsored') }

  it { should have_many(:activities) }
  it { should have_many(:repositories) }
  it { should have_many(:members) }
  it { should have_many(:students) }
  it { should have_many(:coaches) }
  it { should have_many(:mentors) }
  it { should have_many(:roles) }

  it { should validate_uniqueness_of(:name) }

  describe 'creating a new team' do
    before  { subject.save! }

    it 'sets the team number' do
      subject.reload.number.should == 1
    end
  end

  describe 'display_name' do
    let(:students) { [User.new(name: 'Nina'), User.new(name: 'Maya')] }

    before { subject.save! }

    it 'returns "Team ?" if no name given' do
      subject.display_name.should == 'Team ?'
    end

    it 'returns "Team Blue" if name given' do
      subject.name = 'Blue'
      subject.display_name.should == 'Team Blue'
    end
  end
end
