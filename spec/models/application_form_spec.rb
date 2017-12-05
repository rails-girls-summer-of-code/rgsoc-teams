require 'spec_helper'

RSpec.describe ApplicationForm, type: :model do
  let(:team) { build_stubbed :team }
  let(:user) { build_stubbed :user }

  subject { described_class.new team: team, current_user: user }

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
        allow(team).to receive(:application).and_return Application.new
        subject = described_class.new team: team
        expect(subject.application).to eql team.application
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

  describe '#persisted?' do
    it 'returns true if application is present' do
      allow(team).to receive(:application).and_return Application.new
      expect(subject).to be_persisted
    end

    it 'returns false if application is not present' do
      expect(subject).not_to be_persisted
    end
  end
end
