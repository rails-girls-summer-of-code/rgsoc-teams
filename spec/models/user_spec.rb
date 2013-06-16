require 'spec_helper'

describe User do
  it { should have_many(:teams) }
  it { should have_many(:roles) }
  it { should validate_presence_of(:github_handle) }
  it { should validate_uniqueness_of(:github_handle) }

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
end
