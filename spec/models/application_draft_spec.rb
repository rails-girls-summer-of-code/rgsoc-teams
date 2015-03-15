require 'spec_helper'

RSpec.describe ApplicationDraft do
  it_behaves_like 'HasSeason'

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }

    context 'for coaches\' attributes' do
      it { is_expected.not_to validate_presence_of :coaches_hours_per_week }
      it { is_expected.not_to validate_presence_of :coaches_why_team_successful }

      context 'when applying' do
        it { is_expected.to validate_presence_of(:coaches_hours_per_week).on(:apply) }
        it { is_expected.to validate_presence_of(:coaches_why_team_successful).on(:apply) }
      end
    end
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

    shared_examples_for 'checks for role' do |role|
      it "returns '#{role.titleize}'" do
        create "#{role}_role", user: user, team: team
        expect(subject.role_for(user)).to eql role.titleize
      end
    end

    it_behaves_like 'checks for role', 'student'
    it_behaves_like 'checks for role', 'coach'
    it_behaves_like 'checks for role', 'mentor'
  end

  describe '#ready?' do
    it 'returns false' do
      expect(subject).not_to be_ready
    end
  end

end
