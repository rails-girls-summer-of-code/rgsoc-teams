require 'spec_helper'

RSpec.describe Student do

  let(:user) { build_stubbed(:user) }

  subject { described_class.new user }

  describe 'its constructor' do
    it 'sets the user' do
      subject = described_class.new user
      expect(subject.user).to eql user
    end

    it 'sets an anonymous user' do
      subject = described_class.new
      expect(subject.user).to be_a_new User
    end
  end

  describe '#name' do
    it 'returns the user\'s name' do
      user.name = 'Foobar'
      user.github_handle = ''
      expect(subject.name).to eql 'Foobar'
    end

    it 'returns the user\'s github handle' do
      user.name = ''
      user.github_handle = 'foomeister'
      expect(subject.name).to eql 'foomeister'
    end
  end

end
