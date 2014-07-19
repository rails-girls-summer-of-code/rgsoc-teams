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

  describe 'sponsored' do

    it 'should be sponsored' do
      expect(subject.sponsored?).to eql true
    end
  end

  describe 'creating a new team' do
    before do
      Team.destroy_all
      subject.save!
    end

    it 'sets the team number' do
      expect(subject.reload.number).to eql 1
    end
  end

  describe '#display_name' do
    let(:students) { [User.new(name: 'Nina'), User.new(name: 'Maya')] }

    before { subject.save! }

    it 'returns "Team ?" if no name given' do
      expect(subject.display_name).to be == 'Team Sinatra'
    end

    it 'returns "Team Blue" if name given' do
      subject.name = 'Blue'
      expect(subject.display_name).to be == 'Team Blue (Sinatra)'
    end
  end

  describe '#github_handle=' do
    it 'keeps an empty handle' do
      expect(Team.new(github_handle: nil).github_handle).to be_nil
    end

    it 'strips leading/tailing spaces' do
      expect(Team.new(github_handle: ' foo ').github_handle).to be == 'foo'
    end

    it 'extracts the handle from a github url' do
      expect(Team.new(github_handle: 'https://github.com/foo').github_handle).to be == 'foo'
    end
  end

  describe '#twitter_handle=' do
    it 'keeps an empty handle' do
      expect(Team.new(twitter_handle: nil).twitter_handle).to be_nil
    end

    it 'with an @' do
      expect(Team.new(twitter_handle: '@foo').twitter_handle).to be == '@foo'
    end

    it 'strips leading/tailing spaces' do
      expect(Team.new(twitter_handle: ' foo ').twitter_handle).to be == '@foo'
    end

    it 'extracts the handle from a github url' do
      expect(Team.new(twitter_handle: 'https://twitter.com/foo').twitter_handle).to be == '@foo'
    end
  end

  describe 'checking' do
    let(:user) { FactoryGirl.create(:user) }

    it 'calls set_last_checked' do
      subject.should_receive(:set_last_checked)
      subject.checked = user
      subject.save!
    end

    it 'changes last_checked_*' do
      expect do
        subject.checked = user
        subject.save!
      end.to change(subject, :last_checked_by) && change(subject, :last_checked_at)
    end

  end
end
