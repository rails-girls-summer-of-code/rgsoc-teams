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

    context 'settings the application' do
      it 'finds a team\'s existing application' do
        team.application = build_stubbed(:application)
        subject = described_class.new team: team
        expect(subject.application).to team.application
      end

      it 'leaves application blank' do
        subject = described_class.new team: team
        expect(subject.application).to be_nil
      end
    end
  end

  describe '#students' do
    it 'finds all two students in a team' do
    end
  end
end
