require 'spec_helper'

RSpec.describe ApplicationDraft do
  it_behaves_like 'HasSeason'

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }
  end

  context 'with callbacks' do
    it 'sets the current season if left blank' do
      expect { subject.valid? }.to \
        change { subject.season }.from(nil).to(Season.current)
    end
  end

  describe '#role_for' do
    let(:user) { create :user }
    let(:team) { create :team }

    subject { described_class.new team: team }

    it 'returns "Student"' do
      create :student_role, user: user, team: team
      expect(subject.role_for(user)).to eql 'Student'
    end

    it 'returns "Coach"' do
      create :coach_role, user: user, team: team
      expect(subject.role_for(user)).to eql 'Coach'
    end

    it 'returns "Mentor"' do
      create :mentor_role, user: user, team: team
      expect(subject.role_for(user)).to eql 'Mentor'
    end
  end

end
