require 'rails_helper'

RSpec.describe Student, type: :model do
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

  describe '#current_team' do
    subject(:current_team) { described_class.new(user).current_team }

    let(:user) { create(:user) }

    it { is_expected.to be_nil }

    context 'when the user is in teams for multiple seasons' do
      let(:old_season) { create :season, name: '2015' }
      let(:old_team)   { create :team, season: old_season }
      let(:team)       { create :team, :in_current_season }

      before { create :student_role, user: user, team: old_team }

      it 'returns the team where she is a student for the current_season' do
        create :student_role, user: user, team: team
        expect(current_team).to eql team
      end

      it 'returns nothing if the user has a different role in the current_season' do
        create :coach_role, user: user, team: team
        expect(current_team).to be_nil
      end
    end
  end

  describe '#current_drafts' do
    it 'returns an empty list if no team can be determined' do
      expect(subject.current_drafts).to eql []
    end

    context 'with a team' do
      let(:user) { create :user }
      let(:team) { create :team, :in_current_season }

      before do
        create :student_role, user: user, team: team
        team.application_drafts.create(season: create(:season, name: 1999))
      end

      subject { described_class.new user }

      it 'returns all drafts of the current season' do
        draft = team.application_drafts.create
        expect(subject.current_drafts).to match_array [draft]
      end
    end
  end

  describe '#current_draft' do
    it 'returns an empty list if no team can be determined' do
      expect(subject.current_draft).to be_nil
    end

    it 'returns the first draft' do
      drafts = ['first', 'second']
      allow(subject).to receive(:current_drafts).and_return(drafts)
      expect(subject.current_draft).to eq 'first'
    end
  end
end
