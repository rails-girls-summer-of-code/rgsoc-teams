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

  describe 'after_create' do
    let(:user) { User.create(github_handle: 'octocat') }

    it 'completes attributes from Github' do
      attrs = user.attributes.slice(*%w(github_id email location))
      attrs.values.should == [1, 'octocat@github.com', 'San Francisco']
    end
  end

  describe '#github_url' do
    it 'should return github url' do
      @user = User.new(github_handle: 'rails-girl')
      @user.github_url.should == 'https://github.com/rails-girl'
    end
  end

  describe '#name_or_handle' do
    it 'should return name if existed' do
      @user = User.new(name: 'trung')
      @user.name_or_handle.should == 'trung'
    end

    it 'should return github_handle if name is not available' do
      @user = User.new(github_handle: 'rails-girl')
      @user.name_or_handle.should == 'rails-girl'
    end
  end

  context 'with roles' do
    it 'lists unique teams even with different roles' do
      coach_role = FactoryGirl.create(:coach_role)
      user, team = coach_role.user, coach_role.team
      FactoryGirl.create(:mentor_role, user: user, team: team)
      expect(user.teams.count).to eql 1
    end
  end
end
