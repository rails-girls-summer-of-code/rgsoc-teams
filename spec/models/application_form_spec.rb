require 'spec_helper'

RSpec.describe ApplicationForm do
  let(:team) { build_stubbed :team }
  let(:user) { build_stubbed :user }

  describe 'its contructor' do

    it 'sets the current_user' do
      subject = described_class.new current_user: user
      expect(subject.current_user).to eql user
    end

    it 'sets the team' do
      subject = described_class.new team: team
      expect(subject.team).to eql team
    end

  end
end
