require 'spec_helper'

describe User do
  before :each do
    stub_request(:get, /./).to_return(body: File.read('spec/stubs/github/user.json'))
  end

  it { should have_many(:teams) }
  it { should have_many(:roles) }
  it { should validate_presence_of(:github_handle) }
  it { should validate_uniqueness_of(:github_handle) }
  it { should allow_value('http://example.com').for(:homepage) }
  it { should allow_value('https://example.com').for(:homepage) }
  it { should_not allow_value('example.com').for(:homepage) }

  describe 'scopes' do
    before(:all) do
      @user1 = create(:user)
      @user2 = create(:coach)

      Role.find_by(name: 'coach', user_id: @user2.id).team.update_attribute(:kind, 'Charity')
    end

    describe '.with_assigned_roles' do
      it 'returns users that have any roles assigned' do
        expect(User.with_assigned_roles).to be ==[@user2]
      end
    end

    describe '.with_role' do
      it 'returns users that have matching role name' do
        expect(User.with_role('coach')).to be ==[@user2]
      end
    end

    describe '.with_team_kind' do
      it 'returns users that have matching team kind' do
        expect(User.with_team_kind('Charity')).to be ==[@user2]
      end
    end
  end

  describe 'after_create' do
    let(:user) { User.create(github_handle: 'octocat') }

    it 'completes attributes from Github' do
      attrs = user.attributes.slice(*%w(github_id email location))
      expect(attrs.values).to be == [1, 'octocat@github.com', 'San Francisco']
    end
  end

  describe '#github_url' do
    it 'should return github url' do
      @user = User.new(github_handle: 'rails-girl')
      expect(@user.github_url).to be == 'https://github.com/rails-girl'
    end
  end

  describe '#name_or_handle' do
    it 'should return name if existed' do
      @user = User.new(name: 'trung')
      expect(@user.name_or_handle).to be =='trung'
    end

    it 'should return github_handle if name is not available' do
      @user = User.new(github_handle: 'rails-girl')
      expect(@user.name_or_handle).to be =='rails-girl'
    end
  end

  context 'with roles' do
    before do
      coach_role = FactoryGirl.create(:coach_role)
      @user, team = coach_role.user, coach_role.team
      FactoryGirl.create(:mentor_role, user: @user, team: team)
    end

    it 'lists unique teams even with different roles' do
      expect(@user.teams.count).to eql 1
    end
  end
end
