require 'spec_helper'

describe Team do
  subject { Team.new(kind: 'sponsored', projects: 'Sinatra') }

  it { should have_many(:activities) }
  it { should have_many(:sources) }
  it { should have_many(:members) }
  it { should have_many(:students) }
  it { should have_many(:coaches) }
  it { should have_many(:mentors) }
  it { should have_many(:helpdesks) }
  it { should have_many(:organizers) }
  it { should have_many(:supervisors) }
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
      subject.display_name.should == 'Team Sinatra'
    end

    it 'returns "Team Blue" if name given' do
      subject.name = 'Blue'
      subject.display_name.should == 'Team Blue (Sinatra)'
    end
  end

  describe 'github_handle=' do
    it 'keeps an empty handle' do
      Team.new(github_handle: nil).github_handle.should be_nil
    end

    it 'strips leading/tailing spaces' do
      Team.new(github_handle: ' foo ').github_handle.should == 'foo'
    end

    it 'extracts the handle from a github url' do
      Team.new(github_handle: 'https://github.com/foo').github_handle.should == 'foo'
    end
  end

  describe 'twitter_handle=' do
    it 'keeps an empty handle' do
      Team.new(twitter_handle: nil).twitter_handle.should be_nil
    end

    it 'with an @' do
      Team.new(twitter_handle: '@foo').twitter_handle.should == '@foo'
    end

    it 'strips leading/tailing spaces' do
      Team.new(twitter_handle: ' foo ').twitter_handle.should == '@foo'
    end

    it 'extracts the handle from a github url' do
      Team.new(twitter_handle: 'https://twitter.com/foo').twitter_handle.should == '@foo'
    end
  end
end
